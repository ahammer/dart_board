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
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Expanded(
          child: AuthenticationGate(
            signedIn: (ctx) => buildMessageListView(true),
            signedOut: (ctx) => buildMessageListView(true),
          ),
        ),
      ]));

  Widget buildMessageListView(bool showFooter) => QueryListView(
      reversed: true,
      autoScroll: true,
      headerBuilder: showFooter
          ? (ctx) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                child: Column(
                  children: [
                    Divider(),
                    NewMessageRow(channel_id: widget.channel_id),
                  ],
                ),
              );
            }
          : (ctx) => Center(child: Text("Sign in to post")),
      builder: (idx, ctx, snapshot) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: MessageRow(
            channel_id: widget.channel_id,
            data: snapshot.docs[idx],
          ),
        );
      },
      ref: FirebaseFirestore.instance
          .collection("channels/${widget.channel_id}/messages")
          .orderBy('date', descending: true));
}

class MessageRow extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> data;
  final String channel_id;

  const MessageRow({
    Key? key,
    required this.data,
    required this.channel_id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String photoUrl = data.get("profilePhoto");

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      /// Profile Image
      Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
            color: photoUrl.isEmpty ? Colors.blue : null,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  blurRadius: 6, offset: Offset(3, 3), color: Colors.black26)
            ],
            image: photoUrl.isEmpty
                ? null
                : DecorationImage(image: NetworkImage(photoUrl))),
      ),
      Container(width: 8),
      Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Text(
                      "${data.get("author") ?? "Unknown"}",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Container(width: 16),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Text(
                        "${DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(data.get("date")))}",
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    if (!data.get("uid").isEmpty &&
                        data.get("uid") == locate<AuthenticationState>().userId)
                      IconButton(
                        iconSize: 16,
                        splashRadius: 16,
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          //await FirebaseFirestore.instance.
                          FirebaseFirestore.instance
                              .collection("channels/${channel_id}/messages")
                              .doc(data.id)
                              .delete();
                        },
                      )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("${data.get("message")}")),
                )
              ],
            ),
          ),
        ),
      )
    ]);
  }
}

class NewMessageRow extends StatefulWidget {
  final String channel_id;

  const NewMessageRow({
    Key? key,
    required this.channel_id,
  }) : super(key: key);

  @override
  _NewMessageRowState createState() => _NewMessageRowState();
}

class _NewMessageRowState extends State<NewMessageRow> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final String photoUrl = locate<AuthenticationState>().photoUrl;

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      /// Profile Image
      Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
            color: photoUrl.isEmpty ? Colors.blue : null,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  blurRadius: 6, offset: Offset(3, 3), color: Colors.black26)
            ],
            image: photoUrl.isEmpty
                ? null
                : DecorationImage(image: NetworkImage(photoUrl))),
      ),
      Container(width: 8),
      Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Text(
                      locate<AuthenticationState>().username,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          minLines: 1,
                          maxLines: 50,
                          controller: _controller,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: MaterialButton(
                          child: Container(
                            width: 100,
                            child: Center(child: Text("Post")),
                          ),
                          onPressed: submitMessage,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )
    ]);
  }

  Future<void> submitMessage() async {
    await FirebaseFirestore.instance
        .collection("channels/${widget.channel_id}/messages")
        .add({
      "message": _controller.text,
      "date": DateTime.now().millisecondsSinceEpoch,
      "author": locate<AuthenticationState>().username,
      "profilePhoto": locate<AuthenticationState>().photoUrl,
      "uid": locate<AuthenticationState>().userId
    });
    _controller.text = "";
  }
}
