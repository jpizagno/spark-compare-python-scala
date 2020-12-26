#!/bin/bash

set -e

echo "Building docker compose image"

###############################################################################
# building Spark base image
################################################################################
echo "Building spark-base image"
docker build -t spark-base ./base
