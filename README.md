# Ifrit [![Latest Release](https://img.shields.io/github/release/imdrasil/ifrit.svg)](https://github.com/imdrasil/ifrit/releases)

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
require "ifrit/inheritable_json" # for particular pact like InheritableJSON
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
- `#to_bool` - parses string or integer for boolean value interpretation.

#### Converter

```crystal
require "ifrit/converter"

Ifrit.typed_hash({"a" => 1, "b" => "asd"}, String, String | Int32) # Hash(String, String | Int32)
```

#### Symbol Table

```crystal
require "ifrit/symbol_table"

include SymbolTable::Methods

a = s(:asd)
# ...
"asd".to_sym # :asd
```

#### Inheritable JSON

```crystal
require "ifrit/inheritable_json"

class A
  extend InheritableJSON

  json_mapping({
    a:               String,
    b:               {type: Int32},
    nillable_field1: {type: String?},
    nillable_field2: {type: String?},
  })
end

private class B < A
end

private class C < B
  json_mapping({
    with_default: {type: String?, default: "default"},
  })
end
```

#### Hash with indifferent access

```crystal
require "ifrit/hash_with_indifferent_access"

h = HashWithIndifferentAccess(Int32).new
h[:asd] = 23
h["asd"] # 23
```

## Contributing

Before start working on any new feature please create an issue to discuss it.

1. Fork it ( https://github.com/imdrasil/ifrit/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [imdrasil](https://github.com/imdrasil) Roman Kalnytskyi - creator, maintainer
