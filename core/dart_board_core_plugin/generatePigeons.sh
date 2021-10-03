#!/bin/bash

flutter pub run pigeon \
  --input pigeons/nav.dart \
  --dart_out lib/nav_api.dart \
  --java_out ./android/src/main/java/io/dartboard/navapi/Api.java \
  --java_package "io.dartboard.navapi"

# For ios...
#  --objc_header_out ios/Runner/pigeon.h \
#  --objc_source_out ios/Runner/pigeon.m \
