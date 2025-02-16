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

To use a custom config file, set the config_path parameter.

```
typos.run config_path: "_typos.toml"
```


### GitHub actions

```yaml
name: Danger

on: [pull_request]

jobs:
  danger:
    runs-on: ubuntu-latest
    if: github.event_name  == 'pull_request'
    steps:
    - uses: actions/checkout@v2
    - uses: ruby/setup-ruby@v1
      with:
        ruby-version: 3.4
        bundler-cache: true

    - name: Install typos
      uses: baptiste0928/cargo-install@v3
      with:
        crate: typos-cli
        version: 1.29.7

    - run: bundle exec danger
      env:
        DANGER_GITHUB_API_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```


### GitHub actions 

directly install typos from binary

```yaml
name: Danger

on: [pull_request]

jobs:
  danger:
    runs-on: ubuntu-latest
    if: github.event_name  == 'pull_request'
    steps:
    - uses: actions/checkout@v2
    - uses: ruby/setup-ruby@v1
      with:
        ruby-version: 3.4
        bundler-cache: true

    - name: Install typos
      run: |
        wget https://github.com/crate-ci/typos/releases/download/v1.29.7/typos-v1.29.7-x86_64-unknown-linux-musl.tar.gz
        tar xf typos-v1.29.7-x86_64-unknown-linux-musl.tar.gz
        mkdir -p $HOME/.cargo/bin
        mv typos $HOME/.cargo/bin/
        echo "$HOME/.cargo/bin" >> $GITHUB_PATH
        typos --version

    - run: bundle exec danger
      env:
        DANGER_GITHUB_API_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

