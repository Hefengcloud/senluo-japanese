#!/bin/bash
echo "Building flutter to web"

flutter build web --release --base-href="/senluo_business_flutter/"

if [ ! -d "docs" ]; then
    mkdir docs
    echo "Created 'docs' folder"
else
    echo "'docs' folder already exists"
fi

cp -r build/web* docs/
echo "Copied build/web* to docs/"
