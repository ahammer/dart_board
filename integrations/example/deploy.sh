#!/bin/bash
flutter build web --release
cp -rf build/web/* release/public/
cd release
firebase deploy

