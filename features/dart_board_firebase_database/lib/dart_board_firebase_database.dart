import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_firebase_core/dart_board_firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DartBoardFirebaseDatabaseFeature extends DartBoardFeature {
  @override
  List<DartBoardFeature> get dependencies => [DartBoardFirebaseAppFeature()];

  @override
  String get namespace => "DartBoardFirebaseDatabaseFeature";
}

/// Able to take a Collection Ref and pass it into builder's with a snapshot
class CollectionView extends StatelessWidget {
  final CollectionReference ref;
  final Widget Function(int, BuildContext, QuerySnapshot) builder;

  const CollectionView({Key? key, required this.ref, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<QuerySnapshot>(
        stream: ref.snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemBuilder: (
                  ctx,
                  idx,
                ) =>
                    builder(idx, ctx, snapshot.data!),
                itemCount: snapshot.data!.docs.length);
          } else {
            return CircularProgressIndicator();
          }
        },
      );
}

/// Widget to render a Query to a ListView
class QueryListView extends StatelessWidget {
  final bool reversed;
  final Query ref;
  final Widget Function(int, BuildContext, QuerySnapshot) builder;
  final Widget Function(BuildContext)? footerBuilder;

  const QueryListView(
      {Key? key,
      required this.ref,
      required this.builder,
      this.footerBuilder,
      this.reversed = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<QuerySnapshot>(
        stream: ref.snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                reverse: reversed,
                itemBuilder: (
                  ctx,
                  idx,
                ) {
                  if (idx < snapshot.data!.docs.length) {
                    return builder(idx, ctx, snapshot.data!);
                  } else {
                    // We know footerBuilder is not null, because
                    // it's the condition for the extra item
                    return footerBuilder!(ctx);
                  }
                },
                itemCount: snapshot.data!.docs.length +
                    (footerBuilder != null ? 1 : 0));
          } else {
            return CircularProgressIndicator();
          }
        },
      );
}
