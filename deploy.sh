#!/bin/bash

cd integrations/blank
flutter build web --release
firebase deploy

cd ../..

cd integrations/example
flutter build web --release
firebase deploy
firebase deploy
cd ../..

cd homepage
npm run build
firebase deploy

