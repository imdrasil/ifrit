require "./version"

module Ifrit
  # Renders convertable macros.
  #
  # These convert macros are designed to provide interface for converting hash to exact type
  # (e.g. `{"asd" => "asd"} of String | Int64 => Float32 | Symbol | String` to `String => String`).
  # Adds next macros:
  # - `%typed_hash` - converts given hash literal to one with given key type (`key`) and value type (`types`); without cycles;
  # - `%sym_hash_cast` - is a shortcut for `%typed_hash` for symbol keys;
  # - `%str_hash_cast` - is a shortcut for `%typed_hash` for string keys;
  # - `%typed_hash_cast` - converts given variable or hash literal to one with given key (`key`) and value (`types`) type;
  # - `%sym_hash` - is a shortcut for `%typed_hash_cast` for symbol keys;
  # - `%str_hash` - is a shortcut for `%typed_hash_cast` for string keys;
  # - `%typed_array_cast` - converts given array variable or array literal to one with given types (`klass`);
  # - `%typed_array` - converts given array literal to array with given type (`klass`); without cycles;
  # - `%stringify_hash` - calls `#to_s` on keys and converts all values to given type (`klass`);
  #
  # ```
  # Ifrit.str_hash({:asd => "qwe"}, String)
  #
  # class Test
  #   extend Ifrit
  #
  #   def some_method
  #     str_hash({:asd => "qwe"}, String)
  #   end
  # end
  # ```
  macro render_macros
    # accepts only hash literals
    # example: Ifrit.typed_hash({"a" => 1, "b" => "b"}, String, Int32 | String)
    macro typed_hash(hash, key, types)
      begin
        %hash = {} of \{{key.id}} => \{{types.id}}
        \{% type = key.resolve %}
        \{% for k, v in hash %}
          \{% if k.is_a?(MacroId) %}
            \{% if type.union? %}
              \{% if type.union_types.includes?(String) %}
                \{% name = k.stringify %}
              \{% elsif type.union_types.includes?(Symbol) %}
                \{% name = ":#{k}".id %}
              \{% else %}
                \{% name = k %}
              \{% end %}
            \{% elsif type == String %}
              \{% name = "#{k}" %}
            \{% elsif  type == Symbol %}
              \{% name = ":#{k}".id %}
            \{% else %}
              \{% name = k %}
            \{% end %}
          \{% else %}
            \{% name = k %}
          \{% end %}
          %hash[\{{name}}] = \{{v}}.as(\{{types.id}})
        \{% end %}
        %hash
      end
    end

    # accepts any hash or named tuple
    # example: Ifrit.as_sym_hash(hash, String | Int32)
    macro sym_hash_cast(hash, types)
      Ifrit.typed_hash_cast(\{{hash}}, Symbol, \{{types}})
    end

    macro str_hash_cast(hash, types)
      Ifrit.typed_hash_cast(\{{hash}}, String, \{{types}})
    end

    # accepts any hash
    macro typed_hash_cast(hash, key, types)
      begin
        %buf = {} of \{{key}} => \{{types.id}}
        \{{hash.id}}.each { |k, v| %buf[k.as(\{{key}})] = v.as(\{{types.id}}) }
        %buf
      end
    end

    # accepts hash literal
    macro sym_hash(hash, types)
      Ifrit.typed_hash(\{{hash}}, Symbol, \{{types}})
    end

    # accepts hash literal
    macro str_hash(hash, types)
      Ifrit.typed_hash(\{{hash}}, String, \{{types}})
    end

    # accepts any array
    macro typed_array_cast(arr, klass)
      begin
        array = [] of \{{klass}}
        \{{arr}}.each { |e| array << e.as(\{{klass}}) }
        array
      end
    end

    # accepts array literal
    macro typed_array(arr, klass)
      begin
        [
        \{% for v in arr %}
          \{{v}}.as(\{{klass}}),
        \{% end %}
        ]
      end
    end

    # accepts any hash
    macro stringify_hash(hash, types)
      begin
        %hash = {} of String =>\{{types}}
        \{{hash}}.each do |k, v|
          %hash[k.to_s] = v.as(\{{types}})
        end
        %hash
      end
    end
  end

  render_macros

  macro extended
    ::Ifrit.render_macros
  end
end
