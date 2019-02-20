#!/usr/bin/env bash

set -e
set -u
set -x

for x in omero-dsl-plugin omero-blitz-plugin ice-builder-gradle;
do
    pushd $x
    ./gradlew publishToMavenLocal
    popd 
done
