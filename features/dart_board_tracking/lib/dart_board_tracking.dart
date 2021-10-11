import 'package:dart_board_core/dart_board_core.dart';
import 'package:dart_board_widgets/dart_board_widgets.dart';
import 'package:flutter/material.dart';

/// Like authentication, this serves as API
/// it should be paired with another
class DartBoardTrackingFeature extends DartBoardFeature {
  final _delegates = <TrackingDelegate>[];
  @override
  String get namespace => "tracking";

  void trackPage(
    BuildContext context,
    String name,
    Map<String, dynamic> extras,
  ) =>
      _delegates.forEach((delegate) => delegate.trackPage(
            context,
            name,
            extras,
          ));

  void trackAction(
    BuildContext context,
    String name,
    Map<String, dynamic> extras,
  ) =>
      _delegates.forEach((delegate) => delegate.trackPage(
            context,
            name,
            extras,
          ));
}

/// Use this to register a delegate, add to the child feature
class TrackingDelegateAppDecoration implements DartBoardDecoration {
  final String name;
  final bool enabled = true;
  final TrackingDelegate delegate;

  TrackingDelegateAppDecoration({
    required this.name,
    required this.delegate,
  });

  @override
  WidgetWithChildBuilder get decoration => (ctx, child) => LifeCycleWidget(
        key: ValueKey("tracking_delegate_$name"),
        init: (ctx) {
          findByName<DartBoardTrackingFeature>("tracking")
              ._delegates
              .add(delegate);
        },
        child: child,
      );
}

/// Implement this in delegates and register with TrackingDelegateAppDecoration
abstract class TrackingDelegate {
  /// Implement this to track a page
  void trackPage(
    BuildContext context,
    String name,
    Map<String, dynamic> extras,
  );

  /// Implement this to track an action
  void trackAction(
    BuildContext context,
    String name,
    Map<String, dynamic> extras,
  );
}

/// Global public API
void trackPage(BuildContext context, String name,
        [Map<String, dynamic>? extras]) =>
    findByName<DartBoardTrackingFeature>("tracking")
        .trackPage(context, name, extras ?? {});

void trackAction(BuildContext context, String name,
        [Map<String, dynamic>? extras]) =>
    findByName<DartBoardTrackingFeature>("tracking")
        .trackAction(context, name, extras ?? {});

// Registers a page action when this becomes alive
class TrackedScopeWidget extends StatelessWidget {
  final Widget child;

  /// This TrackedScopeWidget will fire a page event when it comes into scope
  /// The page name will match this
  final String pageName;

  /// This scope should only change if you want to trigger a new event.
  /// e.g. page_id12345
  ///
  /// It'll be included in the extras as "scopeId"
  final String scopeId;

  /// Extras you want to also bundle here
  final Map<String, dynamic> extras;

  const TrackedScopeWidget({
    Key? key,
    required this.child,
    required this.pageName,
    required this.scopeId,
    this.extras = const {},
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => LifeCycleWidget(
      key: ValueKey(scopeId),
      init: (ctx) =>
          trackPage(ctx, pageName, {"scopeId": scopeId}..addAll(extras)),
      child: child);
}
