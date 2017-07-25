module Ifrit
  macro render_macrosses
    # accepts only compile-time hashes
    # example: Ifrit.typed_hash({"a" => 1, "b" => "b"}, String, Int32 | String)
    macro typed_hash(hash, key, types)
      begin
        %hash = {} of \{{key.id}} => \{{types.id}}
        \{% for k, v in hash %}
          %hash[\{{k}}] = \{{v}}.as(\{{types.id}})
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

    # accepts compile-time hash
    macro sym_hash(hash, types)
      Support.typed_hash(\{{hash}}, Symbol, \{{types}})
    end

    # accepts compile-time hash
    macro str_hash(hash, types)
      Support.typed_hash(\{{hash}}, String, \{{types}})
    end

    # accepts any array
    macro typed_array_cast(arr, klass)
      \{{arr}}.map { |e| e.as(\{{klass}}) }
    end

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
        \{{hash.id}}.each do |k, v|
          %hash[k.to_s] = v
        end
        %hash
      end
    end
  end

  render_macrosses
end
