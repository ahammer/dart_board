import 'package:dart_board_core/dart_board.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RepositoryFeature extends DartBoardFeature {
  /// We give the repository to the feature to wire up.
  final Repository repository;

  @override
  String get namespace => "RepositoryFeature";

  RepositoryFeature({required this.repository});

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            name: "RepositoryDecoration",
            decoration: (ctx, child) =>
                Provider.value(value: repository, child: child))
      ];
}

/// A short record placeholder
/// meant to represent a search result
class ShortRecord {
  final int id;
  final String title;
  final String price;

  ShortRecord({required this.id, required this.title, required this.price});
}

/// A long record, meant to represent the details page
class LongRecord extends ShortRecord {
  LongRecord({required int id, required String title, required String price})
      : super(id: id, title: title, price: price);
}

/// This messenger is used to pass messages to the bound repository
///
/// This is syntactic sugar for the apps to use.
class RepositoryMessenger {
  static Future<List<ShortRecord>> performSearch(BuildContext context) =>
      Provider.of<Repository>(context, listen: false).performSearch();
  static Future<LongRecord> fetchDetails(BuildContext context, int id) =>
      Provider.of<Repository>(context, listen: false).fetchDetails(id);
}

/// This is the repository
///
/// It's responsible for fetching and returning details
abstract class Repository {
  Future<List<ShortRecord>> performSearch();
  Future<LongRecord> fetchDetails(int id);
}

/// This is a mock repository
class MockRepository extends Repository {
  /// Internal record list, we generate on the fly.
  late final List<LongRecord> _records = List.generate(
      200,
      (index) => LongRecord(
          id: index,
          title: Faker.instance.animal.animal(),
          price: Faker.instance.commerce.price()));

  @override
  Future<List<ShortRecord>> performSearch() async {
    return _records;
  }

  @override
  Future<LongRecord> fetchDetails(int id) async => _records[id];
}
