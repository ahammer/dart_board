import 'package:dart_board_chat/message_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChatConfig {
  Widget buildMessageRow(
      {required String id,
      required String uid,
      required String channelId,
      required String photo,
      required String author,
      required String body,
      required String date}) {
    return MessageRow(
        id: id,
        uid: uid,
        channelId: channelId,
        photoUrl: photo,
        author: author,
        body: body,
        date: date);
  }
}
