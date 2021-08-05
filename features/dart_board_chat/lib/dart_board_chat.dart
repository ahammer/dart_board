import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_board_authentication/dart_board_authentication.dart';
import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_core/interface/dart_board_interface.dart';
import 'package:dart_board_firebase_database/dart_board_firebase_database.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

/// Chat functionality for Dart Board.
///
class DartBoardChatFeature extends DartBoardFeature {
  @override
  get namespace => "chat";

  @override
  get dependencies =>
      [DartBoardFirebaseDatabaseFeature(), DartBoardAuthenticationFeature()];

  @override
  get routes => [
        NamedRouteDefinition(
            route: "/chat", builder: (ctx, settings) => ChatWidget())
      ];
}

class ChatWidget extends StatefulWidget {
  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("channels")
        .get()
        .then((value) => setState(() => _id = value.docs[0].id));
  }

  String? _id;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [LoginButton()],
          title: Text(
            "Chat: " + (_id ?? ""),
          ),
        ),
        drawer: Container(
          width: 200,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: FittedBox(
                    child: Text(
                      "Channels",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Card(
                      child: Container(
                width: double.infinity,
                child: ChannelWidget(
                  selection: _id ?? "",
                  onTapped: (String id) {
                    Navigator.of(context).pop();
                    setState(() => _id = id);
                  },
                ),
              ))),
            ],
          ),
        ),
        body: (_id != null)
            ? MessageWidget(channel_id: _id!)
            : Container(
                child: Text("No channel selected"),
              ),
      );
}

class ChannelWidget extends StatelessWidget {
  final String selection;
  final Function(String id) onTapped;
  const ChannelWidget({
    Key? key,
    required this.onTapped,
    required this.selection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CollectionView(
      builder: (idx, ctx, snapshot) => ListTile(
        selected: snapshot.docs[idx].reference.id == selection,
        title: Text("${snapshot.docs[idx].get("name")}"),
        onTap: () => this.onTapped(snapshot.docs[idx].reference.id),
      ),
      ref: FirebaseFirestore.instance.collection("channels"),
    );
  }
}

class MessageWidget extends StatefulWidget {
  final String channel_id;

  MessageWidget({
    Key? key,
    required this.channel_id,
  }) : super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  final _controller = TextEditingController();

//
//
//,
  @override
  Widget build(BuildContext context) => QueryView(
      builder: (idx, ctx, snapshot) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 32,
                  height: 32,
                  color: Colors.blue,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "${snapshot.docs[idx].get("author") ?? "Unknown"}",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                            "${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(snapshot.docs[idx].get("date")))}")
                      ],
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text("${snapshot.docs[idx].get("message")}"))
                  ],
                ),
              )
            ]),
          ),
      ref: FirebaseFirestore.instance
          .collection("channels/${widget.channel_id}/messages")
          .orderBy('date', descending: false));

  Future<void> submitMessage() async {
    await FirebaseFirestore.instance
        .collection("channels/${widget.channel_id}/messages")
        .add({
      "message": _controller.text,
      "date": DateTime.now().millisecondsSinceEpoch,
      "author": locate<AuthenticationState>().username
    });
    _controller.text = "";
  }
}
