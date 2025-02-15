# danger-typos

[Danger](http://danger.systems/ruby/) plugin for [typos](https://github.com/crate-ci/typos).

## Installation

    $ gem install danger-typos

`typos` also needs to be installed before you run Danger.

## Usage

Add this to Dangerfile.

```
typos.run
```

If you want to specify typos bin file, you can set a bin path to the binary_path parameter.

```
typos.binary_path = "path/to/typos"
typos.run
```


