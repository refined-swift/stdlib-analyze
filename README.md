
# stdlib-analyze

For the development, maintenance and testing of [Refined Swift](https://github.com/refined-swift) framework to be scalable, automatic processes of analysis and code generation need to be implemented.

This repository is where the development of the *Swift Standard Library analysis tool* (a.k.a. `analyze`) takes place.

## Status

Current implementation is just a *rough prototype*. It analyses the sources of the core of the [Swift Standard Library](https://github.com/apple/swift/tree/master/stdlib/public/core) and produces the JSON files required by the [GYB](https://github.com/apple/swift/blob/master/utils/gyb.py) templates of the other projects in the framework.


## Usage

```
# Usage:
# $ ./analyze.sh <swift_version>
```

### Example: Swift 5.0

```
./analyze.sh 5.0
```

Upon completion:

- `analyze`executable will be in `/Products/` directory;
- JSON output will be in `./Products/5.0/` directory.

## License

`analyze` is released under the MIT license. See LICENSE file for details.

