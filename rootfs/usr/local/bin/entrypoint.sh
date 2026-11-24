#!/usr/bin/env bash
# Runs the given command as is: graphify-build by default, but also `graphify
# query ...`, or any other tool installed in a derived image.
set -eu
exec "$@"
