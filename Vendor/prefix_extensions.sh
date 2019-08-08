#!/bin/bash

# Exit when any command fails
set -e

# Check parameter count
if [ "$#" -ne 1 ]; then
echo "Usage:   $0 <type_name>"
    echo "Example: $0 ClosedRange"
    exit 1
fi

type=$1
substitution='s/extension[ \n]+('${type}'[^a-zA-Z][a-zA-Z0-9_\.\:, \n]+)[ \n]+where[ \n]+/extension _\1 where /g'

cd swift-stdlib

for f in `ls *.swift`
do
    echo "Processing ${f}"
    cat ${f} | perl -p -000 -e "${substitution}" | tee ${f}
done
