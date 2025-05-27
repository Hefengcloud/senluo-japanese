#!/bin/bash
echo "Building flutter to web"

flutter clean web
flutter build web --release --base-href="/senluo-business/"

rm -rf ./docs
mkdir docs
echo "Created 'docs' folder"

cp -r build/web/* docs/
echo "Copied build/web/* to docs/"

git ci -am'update docs'
git push -u origin main
echo "Pushed to github"
