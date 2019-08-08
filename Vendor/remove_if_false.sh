#!/bin/bash

cd swift-stdlib
for f in `ls *.swift`
do
	echo "Processing ${f}"
	sed -i '' '/#if false/,/#endif/d' ${f}
done
