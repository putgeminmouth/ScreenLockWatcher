#!/bin/bash

WORK=$(mktemp -d)
RELEASE=$(mktemp -d)
mkdir -p $WORK/build

echo "WORK ${WORK}"

xcodebuild archive -configuration Release -project ScreenLockWatcher.xcodeproj -scheme ScreenLockWatcher -archivePath $WORK/build

OSVER=$(sw_vers | grep ProductVersion | awk '{print $2}')
BINDIR=$WORK/build.xcarchive/Products/usr/local/bin
BIN=ScreenLockWatcher
OSBIN=${BIN}_macos_${OSVER}

pushd $RELEASE

cp $BINDIR/$BIN $BIN
ln -s $BIN $OSBIN

tar czvf ScreenLockWatcher.tar.gz *

popd

echo "WORK ${WORK}"
echo "RELEASE ${RELEASE}"

ls -l $RELEASE
