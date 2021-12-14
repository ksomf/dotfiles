#!/usr/bin/env bash

set -e

GIT_ADDRESS=$1; shift
LOCATION=~/.$(basename $GIT_ADDRESS .git)
INSTALL_COMMAND=$@

echo "Target $GIT_ADDRESS -> $LOCATION"
echo "Install: $@"
if [ -d $LOCATION ]; then
	pushd $LOCATION 
	git status -uno | grep 'behind' && git pull && $@
	popd
else
	git clone --depth=1 $GIT_ADDRESS $LOCATION
	pushd $LOCATION && $@ && popd
fi
