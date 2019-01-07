#!/usr/bin/env bash

set -e
set -u
set -x

for x in omero-dsl omero-blitz-plugin ice-builder-gradle;
do
    pushd $x
    gradle publishToMavenLocal
    popd 
done
