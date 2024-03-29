#!/bin/bash
# https://gist.github.com/tonisuter/e47267a25b3dcc90fe75a24d3ed2063a

cd swift-stdlib
for f in `ls *.gyb`
do
	echo "Processing $f"
	name=${f%.gyb}
	../gyb/gyb -D CMAKE_SIZEOF_VOID_P=8 -o $name $f --line-directive ""
done
