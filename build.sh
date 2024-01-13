#!/bin/bash

WORK=$(mktemp -d)
mkdir -p $WORK/build

echo "WORK ${WORK}"

# xcodebuild -list -project ScreenLockWatcher.xcodeproj
xcodebuild archive -project ScreenLockWatcher.xcodeproj -scheme ScreenLockWatcher -archivePath $WORK/build

echo "WORK ${WORK}"
