#!/bin/bash
flutter build web --release
cp -rf build/web/* release/public/playground

cd ../blank
flutter build web --release
cp -rf build/web/* ../example/release/public/blank

cp -rf ../../homepage/dist/* ../example/release/public
cd ../example
cd release
firebase deploy

