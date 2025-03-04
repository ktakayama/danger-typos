# danger-typos

[Danger](http://danger.systems/ruby/) plugin for [typos](https://github.com/crate-ci/typos).

## Installation

    $ gem install danger-typos

`typos` also needs to be installed before you run Danger.

## Usage

Add this to Dangerfile.

```ruby
typos.run
```

If you want to specify typos bin file, you can set a bin path to the binary_path parameter.

```ruby
typos.binary_path = "path/to/typos"
typos.run
```

To use a custom config file, set the config_path parameter.

```ruby
typos.run config_path: "_typos.toml"
```

## Example

<img width="320" src="https://github.com/user-attachments/assets/0fa06466-e945-454e-8d61-73c5cbe8a8ce" />

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
        version: 1.30.1

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
        wget https://github.com/crate-ci/typos/releases/download/v1.30.1/typos-v1.30.1-x86_64-unknown-linux-musl.tar.gz
        tar xf typos-v1.30.1-x86_64-unknown-linux-musl.tar.gz
        mkdir -p $HOME/.cargo/bin
        mv typos $HOME/.cargo/bin/
        echo "$HOME/.cargo/bin" >> $GITHUB_PATH
        typos --version

    - run: bundle exec danger
      env:
        DANGER_GITHUB_API_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

