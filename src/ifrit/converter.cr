require "./version"

module Ifrit
  macro render_macrosses
    # accepts only hash literals
    # example: Ifrit.typed_hash({"a" => 1, "b" => "b"}, String, Int32 | String)
    macro typed_hash(hash, key, types)
      begin
        %hash = {} of \{{key.id}} => \{{types.id}}
        \{% type = key.resolve %}
        \{% for k, v in hash %}
          \{% if k.is_a?(MacroId) %}
            \{% if type.union? %}
              \{% p type.union_types %}
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

    # accepts arrayliteral
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

  render_macrosses

  macro extended
    ::Ifrit.render_macrosses
  end
end
