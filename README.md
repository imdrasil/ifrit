# Ifrit [![Build Status](https://travis-ci.org/imdrasil/ifrit.svg)](https://travis-ci.org/imdrasil/ifrit) [![Latest Release](https://img.shields.io/github/release/imdrasil/ifrit.svg)](https://github.com/imdrasil/ifrit/releases)

Set of useful classes, patches and hacks. Some of them are not "good" enough so be ready to make a deal with **Ifrit**.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  ifrit:
    github: imdrasil/ifrit
```

## Usage

This lib provides modular approach so you should specify what exactly you want to require:

```crystal
require "ifrit/core" # for basic methods
require "ifrit/inheritable_json"
require "ifrit" # to load everything
```

### Pacts

#### Core

```crystal
require "ifrit/core"
```

Includes next methods:

- `#blank?` - behaves same way as rails one;
- `#present?` - opposite to `#blank?`;
-  `String#to_bool` - parses string for boolean value interpretation

#### Converter

```crystal
require "ifrit/converter"
```

#### Symbol Table

```crystal
require "ifrit/symbol_table"
```

#### Inheritable JSON

```crystal
require "ifrit/inheritable_json"
```

#### Hash with indifferent access

```crystal
require "ifrit/hash_with_indifferent_access"
```

## Development

Before start working on any new feature please create an issue to discuss it.

## Contributing

1. Fork it ( https://github.com/imdrasil/ifrit/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [imdrasil](https://github.com/imdrasil) Roman Kalnytskyi - creator, maintainer
