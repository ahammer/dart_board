// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'model.dart';

/// Returns a clock [Widget] with [ClockModel].
///
/// Example:
///   final myClockBuilder = (ClockModel model) => AnalogClock(model);
///
/// Contestants: Do not edit this.
typedef Widget ClockBuilder(ClockModel model);

/// Wrapper for clock widget to allow for customizations.
///
/// Puts the clock in landscape orientation with an aspect ratio of 5:3.
/// Provides a drawer where users can customize the data that is sent to the
/// clock. To show/hide the drawer, double-tap the clock.
///
/// To use the [ClockCustomizer], pass your clock into it, using a ClockBuilder.
///
/// ```
///   final myClockBuilder = (ClockModel model) => AnalogClock(model);
///   return ClockCustomizer(myClockBuilder);
/// ```
/// Contestants: Do not edit this.
class ClockCustomizer extends StatefulWidget {
  const ClockCustomizer(this._clock);

  /// The clock widget with [ClockModel], to update and display.
  final ClockBuilder _clock;

  @override
  _ClockCustomizerState createState() => _ClockCustomizerState();
}

class _ClockCustomizerState extends State<ClockCustomizer> {
  final _model = ClockModel();
  @override
  void initState() {
    super.initState();
    _model.addListener(_handleModelChange);
  }

  @override
  void dispose() {
    _model.removeListener(_handleModelChange);
    _model.dispose();
    super.dispose();
  }

  void _handleModelChange() => setState(() {});

  @override
  Widget build(BuildContext context) => widget._clock(_model);
}
