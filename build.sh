#!/bin/bash

WORK=$(mktemp -d)
mkdir -p $WORK/build

echo "WORK ${WORK}"

# xcodebuild -list -project ScreenLockWatcher.xcodeproj
xcodebuild archive -configuration Release -project ScreenLockWatcher.xcodeproj -scheme ScreenLockWatcher -archivePath $WORK/build

echo "WORK ${WORK}"
echo "BIN $(ls $WORK/build.xcarchive/Products/usr/local/bin/ScreenLockWatcher)"
