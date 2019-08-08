#!/bin/bash

# Exit when any command fails
set -e

# Check parameter count
if [ "$#" -ne 1 ]; then
	echo "Usage:   $0 <swift_version>"
	echo "Example: $0 5.0"
	exit 1
fi

# Read arguments and set up variables
readonly swift_version="${1}"
readonly branch_name="swift-${swift_version}-branch"
readonly output_path="./Products/${swift_version}"

# Change directory to ./Vendor
cd Vendor

# Vendor/: Download gyb
./download_gyb.sh

# Vendor/: Download Swift stdlib sources
./download_swift_stdlib.sh "${branch_name}"

# Vendor/: Generate templated Swift stdlib sources
./process_gyb.sh

# Vendor/: Remove disabled code
./remove_if_false.sh

# Vendor/: Rename extensions with generic where clauses
#./prefix_extensions.sh Range
#./prefix_extensions.sh ClosedRange

# Vendor/: Change directory to repository root
cd ..

# Install dependencies
pod install

# Create json output directory
mkdir -p "${output_path}"

# Build
xcrun xcodebuild archive -workspace analyze.xcworkspace -scheme analyze

# Run
./Products/analyze "${output_path}" --sourcery-path ./Pods/Sourcery/bin/sourcery --sources ./Vendor/swift-stdlib/
