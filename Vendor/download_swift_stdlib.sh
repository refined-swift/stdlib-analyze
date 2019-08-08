#!/bin/bash

readonly output_directory="swift-stdlib"
url="https://api.github.com/repos/apple/swift/tarball"
license="https://raw.githubusercontent.com/apple/swift/master/LICENSE.txt"

if [ ! -z "${1}" ]; then
    url="${url}/${1}"
    license="https://raw.githubusercontent.com/apple/swift/${1}/LICENSE.txt"
fi

mkdir "${output_directory}"

curl -L "${url}" | tar xz --strip-components=4 -C "${output_directory}" "*/stdlib/public/core/*.*"

curl "${license}" > "${output_directory}/LICENSE.txt"
