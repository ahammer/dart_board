import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_board_authentication/dart_board_authentication.dart';
import 'package:dart_board_core/dart_board_core.dart';
import 'package:dart_board_core/interface/dart_board_interface.dart';
import 'package:dart_board_firebase_database/dart_board_firebase_database.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'chat_config.dart';

/// Chat functionality for Dart Board.
///
class DartBoardChatFeature extends DartBoardFeature {
  final ChatConfig chatConfig;

  DartBoardChatFeature({this.chatConfig = const ChatConfig()});

  @override
  get namespace => "chat";

  @override
  get dependencies =>
      [DartBoardFirebaseDatabaseFeature(), DartBoardAuthenticationFeature()];

  @override
  get routes => [
        PathedRouteDefinition([
          [
            NamedRouteDefinition(
                route: "/chat", builder: (ctx, settings) => ChatWidget())
          ],
          [
            UriRoute((context, route) {
              return Material(
                  color: Colors.transparent,
                  child: MessageWidget(channelId: route.pathSegments.last));
            }),
          ]
        ]),
      ];

  static ChatConfig getChatConfig() =>
      (DartBoardCore.instance.findByName("chat") as DartBoardChatFeature)
          .chatConfig;

  /// Enabled for Web, Android and iOS
  @override
  bool get enabled => kIsWeb || Platform.isAndroid || Platform.isIOS;
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
        backgroundColor: Colors.transparent,
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
            ? MessageWidget(channelId: _id!)
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
  Widget build(BuildContext context) => CollectionView(
        builder: (idx, ctx, snapshot) => ListTile(
          selected: snapshot.docs[idx].reference.id == selection,
          title: Text("${snapshot.docs[idx].get("name")}"),
          onTap: () => this.onTapped(snapshot.docs[idx].reference.id),
        ),
        ref: FirebaseFirestore.instance.collection("channels"),
      );
}

class MessageWidget extends StatefulWidget {
  final String channelId;

  MessageWidget({
    Key? key,
    required this.channelId,
  }) : super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Expanded(
          child: AuthenticationGate(
            signedIn: (ctx) => buildMessageListView(showFooter: true),
            signedOut: (ctx) => buildMessageListView(),
          ),
        ),
      ]));

  Widget buildMessageListView({bool showFooter = false}) => QueryListView(
      reversed: true,
      autoScroll: true,
      headerBuilder: showFooter
          ? (ctx) => DartBoardChatFeature.getChatConfig()
              .buildNewMessageRow(channelId: widget.channelId)
          : (ctx) => Center(child: Text("Sign in to post")),
      builder: (idx, ctx, snapshot) {
        return MessageRowShim(
          channelId: widget.channelId,
          data: snapshot.docs[idx],
        );
      },
      ref: FirebaseFirestore.instance
          .collection("channels/${widget.channelId}/messages")
          .orderBy('date', descending: true));
}

class MessageRowShim extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> data;
  final String channelId;

  const MessageRowShim({
    Key? key,
    required this.data,
    required this.channelId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String photoUrl = data.get("profilePhoto");
    final String author = data.get("author") ?? "Unknown";
    final String body = data.get("message");
    final String date = DateFormat.Hm()
        .format(DateTime.fromMillisecondsSinceEpoch(data.get("date")));

    return DartBoardChatFeature.getChatConfig().buildMessageRow(
        channelId: channelId,
        id: data.id,
        uid: data.get("uid") ?? "",
        photo: photoUrl,
        author: author,
        body: body,
        date: date);
  }
}

class DefaultNewMessageRow extends StatefulWidget {
  final String channelId;

  const DefaultNewMessageRow({
    Key? key,
    required this.channelId,
  }) : super(key: key);

  @override
  _DefaultNewMessageRowState createState() => _DefaultNewMessageRowState();
}

class _DefaultNewMessageRowState extends State<DefaultNewMessageRow> {
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
                            onPressed: () => submitMessage(
                                    text: _controller.text,
                                    channelId: widget.channelId)
                                .then((value) => _controller.text = "")),
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
}

Future<void> submitMessage(
        {required String channelId, required String text}) async =>
    await FirebaseFirestore.instance
        .collection("channels/${channelId}/messages")
        .add({
      "message": text,
      "date": DateTime.now().millisecondsSinceEpoch,
      "author": locate<AuthenticationState>().username,
      "profilePhoto": locate<AuthenticationState>().photoUrl,
      "uid": locate<AuthenticationState>().userId
    });

Future<void> deleteMessage(String channelId, String id) async =>
    await FirebaseFirestore.instance
        .collection('channels/$channelId/messages')
        .doc(id)
        .delete();
