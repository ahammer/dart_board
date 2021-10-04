#!/bin/bash

flutter pub run pigeon \
  --input pigeons/spacex.dart \
  --dart_out lib/spacex_api.dart \
  --java_out ./android/src/main/java/io/dartboard/dart_board_spacex_plugin/Api.java \
  --java_package "io.dartboard.dart_board_spacex_plugin"

# For ios...
#  --objc_header_out ios/Runner/pigeon.h \
#  --objc_source_out ios/Runner/pigeon.m \
