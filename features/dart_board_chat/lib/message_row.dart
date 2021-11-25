import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_board_authentication/dart_board_authentication.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart_board_chat.dart';

class MessageRow extends StatelessWidget {
  final String channelId;
  final String id;
  final String photoUrl;
  final String author;
  final String body;
  final String date;
  final String uid;

  const MessageRow({
    Key? key,
    required this.id,
    required this.channelId,
    required this.photoUrl,
    required this.author,
    required this.date,
    required this.body,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      Text(
                        "$author",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Container(width: 16),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Text(
                          "$date",
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      if (!uid.isEmpty &&
                          uid == locate<AuthenticationState>().userId)
                        IconButton(
                          iconSize: 16,
                          splashRadius: 16,
                          icon: Icon(Icons.delete),
                          onPressed: () async => deleteMessage(channelId, id),
                        )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 15),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(body),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ]);
}
