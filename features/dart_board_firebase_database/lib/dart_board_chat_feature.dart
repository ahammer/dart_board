import 'package:dart_board_core/interface/dart_board_interface.dart';
import 'package:dart_board_firebase_database/dart_board_firebase_database.dart';

class DartBoardChatFeature extends DartBoardFeature {
  @override
  List<DartBoardFeature> get dependencies => [DartBoardFirebaseDatabaseFeature()];
}