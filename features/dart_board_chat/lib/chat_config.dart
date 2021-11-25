import 'package:dart_board_chat/message_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'dart_board_chat.dart';

/// Implement this class to over-ride the UI
class ChatConfig {
  const ChatConfig();

  Widget buildMessageRow(
          {required String id,
          required String uid,
          required String channelId,
          required String photo,
          required String author,
          required String body,
          required String date}) =>
      MessageRow(
          id: id,
          uid: uid,
          channelId: channelId,
          photoUrl: photo,
          author: author,
          body: body,
          date: date);

  Widget buildNewMessageRow({required String channelId}) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
        child: Column(
          children: [
            Divider(),
            DefaultNewMessageRow(channelId: channelId),
          ],
        ),
      );
}
