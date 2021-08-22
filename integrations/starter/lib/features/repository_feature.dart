import 'package:dart_board_core/dart_board.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This is a repository Feature, it provides access to a Repository
class RepositoryFeature extends DartBoardFeature {
  /// We give the repository to the feature to wire up.
  final Repository repository;

  /// Namespace is required for all Feature's. It must be unique per-feature
  @override
  String get namespace => "RepositoryFeature";

  /// Construct this feature. Give it a repository interface
  ///
  /// For our cases here, we'll just use a MockRepository
  /// However you could implement your on Repository to fetch over the network
  RepositoryFeature({required this.repository});

  @override
  List<DartBoardDecoration> get appDecorations => [
        /// This decoration injects the Repository into the Widget tree
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
  final String image_url;

  ShortRecord(
      {required this.id,
      required this.title,
      required this.price,
      required this.image_url});
}

/// A long record, meant to represent the details page
class LongRecord extends ShortRecord {
  final String description;
  final String companyName;

  LongRecord({
    required int id,
    required String title,
    required String price,
    required String image_url,
    required this.description,
    required this.companyName,
  }) : super(id: id, title: title, price: price, image_url: image_url);
}

/// This is the interface for a Repository
///
/// It can pull a list of records or a long record by ID
/// In our case ID = idx of the record
abstract class Repository {
  Future<List<ShortRecord>> performSearch();
  Future<LongRecord> fetchDetails(int id);
}

/// This messenger is used to pass messages to the bound repository
///
/// This is syntactic sugar for the apps to use.
/// i.e.
/// `RepositoryMessenger.performSearch(context)`
/// or
/// `RepositoryMessenger.fetchDetails(context, id)`
class RepositoryMessenger {
  /// Perform a "search"
  static Future<List<ShortRecord>> performSearch(BuildContext context) =>
      context.read<Repository>().performSearch();

  /// Fetch the "details"
  static Future<LongRecord> fetchDetails(BuildContext context, int id) =>
      context.read<Repository>().fetchDetails(id);
}

/// This is a mock repository
class MockRepository extends Repository {
  /// Internal record list, we generate on the fly.
  late final List<LongRecord> _records = List.generate(200, (index) {
    final city = Faker.instance.address.country();
    return LongRecord(
        id: index,
        image_url:
            Faker.instance.image.unsplash.nature(w: 200, h: 200, keyword: city),
        title: city,
        price: Faker.instance.commerce.price(),
        description: Faker.instance.commerce.productDescription(),
        companyName: Faker.instance.company.bsNoun());
  });

  @override
  Future<List<ShortRecord>> performSearch() async {
    return _records;
  }

  @override
  Future<LongRecord> fetchDetails(int id) async => _records[id];
}
