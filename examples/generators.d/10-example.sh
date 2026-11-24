#!/usr/bin/env bash
# Example generator: anything that writes into $1/graphify-out/ and gives the
# same output for the same code. Mount it on /etc/graphify/generators.d/.
set -eu
wc -l "$1"/graphify-out/GRAPH_REPORT.md > "$1/graphify-out/report-size.txt"
