# Gradle plugins super project
# ----------------------------
# This dockerfile can be used to build
# the gradle plugins necessary for building
# the omero-build super project. This is mostly
# used by travis to test that the plugins are
# all functioning.

# The BUILD_IMAGE argument can be overwritten
# but this is generally not needed unless you
# would like to provide an existing user maven
# directory (~/.m2) to speed up the build.
ARG BUILD_IMAGE=gradle:5.1.1-jdk8

FROM ${BUILD_IMAGE} as build
USER root
RUN apt-get update && apt-get install -y zeroc-ice-all-dev
RUN mkdir /src && chown 1000:1000 /src
USER 1000
WORKDIR /src
COPY --chown=1000:1000 . /src/
RUN gradle --no-daemon publishToMavenLocal
