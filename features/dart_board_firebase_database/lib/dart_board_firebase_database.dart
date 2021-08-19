import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_firebase_core/dart_board_firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DartBoardFirebaseDatabaseFeature extends DartBoardFeature {
  @override
  List<DartBoardFeature> get dependencies => [DartBoardFirebaseCoreFeature()];

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
class QueryListView extends StatefulWidget {
  final bool reversed;
  final Query ref;
  final Widget Function(int, BuildContext, QuerySnapshot) builder;
  final Widget Function(BuildContext)? footerBuilder;
  final Widget Function(BuildContext)? headerBuilder;
  final bool autoScroll;

  const QueryListView(
      {Key? key,
      required this.ref,
      required this.builder,
      this.footerBuilder,
      this.headerBuilder,
      this.reversed = false,
      this.autoScroll = false})
      : super(key: key);

  @override
  _QueryListViewState createState() => _QueryListViewState();
}

class _QueryListViewState extends State<QueryListView> {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) => StreamBuilder<QuerySnapshot>(
        stream: widget.ref.snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
              _controller.animateTo(0,
                  duration: Duration(seconds: 1), curve: Curves.easeInOut);
            });

            return ListView.builder(
                controller: _controller,
                reverse: widget.reversed,
                itemBuilder: (
                  ctx,
                  idx,
                ) {
                  final trueIdx =
                      (widget.headerBuilder != null) ? idx - 1 : idx;

                  if (trueIdx == -1) {
                    return widget.headerBuilder!(ctx);
                  } else if (trueIdx < snapshot.data!.docs.length) {
                    return widget.builder(trueIdx, ctx, snapshot.data!);
                  } else {
                    // We know footerBuilder is not null, because
                    // it's the condition for the extra item
                    return widget.footerBuilder!(ctx);
                  }
                },
                itemCount: snapshot.data!.docs.length +
                    (widget.footerBuilder != null ? 1 : 0) +
                    (widget.headerBuilder != null ? 1 : 0));
          } else {
            return CircularProgressIndicator();
          }
        },
      );
}
