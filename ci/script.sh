#!/bin/bash

set -ex

if [ -n "$TRAVIS_TAG" ]; then 
	mkdir -p /tmp/packages

	(cd linux && tar -cvzf /tmp/packages/bin-$TRAVIS_COMMIT-linux.tar.gz *)
	(cd mac && tar -cvzf /tmp/packages/bin-$TRAVIS_COMMIT-mac.tar.gz *)

	(cd win32 && zip -r /tmp/packages/bin-$TRAVIS_COMMIT-win32.zip *)
	(cd win64 && zip -r /tmp/packages/bin-$TRAVIS_COMMIT-win64.zip *)
else
	# Make sure pull requests don't trigger this. Should be disabled from the
	# dashboard but lets make sure that this doesn't happen
	if [ "$TRAVIS_PULL_REQUEST" -ne "false" ]; then exit 1; fi

	# Only tags create the packages, normal pushes just create the tags
	git remote add deploy "git@github.com:asarium/scp-prebuilt.git"
	git tag -a "bin-$TRAVIS_COMMIT" -m "Automated prebuilt binary tag"
	git push deploy --tags
fi
