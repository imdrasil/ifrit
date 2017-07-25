require "json"

module InheritableJSON
  macro extended
    macro mapping(properties, strict = false, hook = false)
      INHERITABLE_JSON_MAPPING = {} of String => Hash(String, String)

      \\{% p INHERITABLE_JSON_MAPPING %}
      \\{% for key, value in properties %}
        \\{% properties[key] = {type: value} unless value.is_a?(HashLiteral) || value.is_a?(NamedTupleLiteral) %}
        \\{% str_key = key.id.stringify %}
        \\{% for k1, v2 in properties[key] %}
          \\{% p @type %}
          \\{% INHERITABLE_JSON_MAPPING[str_key][k1.id.stringify] = v2.stringify %}
        \\{% end %}
      \\{% end %}

      \\{% for key, value in properties %}
        @\\{{key.id}} : \\{{value["type"]}} \\{{ (value["nilable"] ? "?" : "").id }}

        \\{% if value["setter"] == nil ? true : value["setter"] %}
          def \\{{key.id}}=(_\\{{key.id}} : \\{{value["type"]}} \\{{ (value["nilable"] ? "?" : "").id }})
            @\\{{key.id}} = _\\{{key.id}}
          end
        \\{% end %}

        \\{% if value["getter"] == nil ? true : value["getter"] %}
          def \\{{key.id}}
            @\\{{key.id}}
          end
        \\{% end %}
      \\{% end %}

      \\{{"render_methods".id}}

      macro inherited
        macro finished
          render_methods
        end
      end
    end

    macro render_methods
      \{% strict = false %}
      \{% p INHERITABLE_JSON_MAPPING %}
      def initialize(%pull : ::JSON::PullParser)
        \{% for key, value in INHERITABLE_JSON_MAPPING %}
          %var\{key.id} = nil
          %found\{key.id} = false
        \{% end %}

        %pull.read_object do |key|
          case key
          \{% for key, value in INHERITABLE_JSON_MAPPING %}
            when \{{value["key"] || key}}
              %found\{key.id} = true

              %var\{key.id} =
                \{% if value["nilable"] || value["default"] != nil %} %pull.read_null_or { \{% end %}

                \{% if value["root"] %}
                  %pull.on_key!(\{{value["root"]}}) do
                \{% end %}

                \{% if value["converter"] %}
                  \{{value["converter"]}}.from_json(%pull)
                \{% elsif value["type"].is_a?(Path) || value["type"].is_a?(Generic) %}
                  \{{value["type"]}}.new(%pull)
                \{% else %}
                  ::Union(\{{value["type"]}}).new(%pull)
                \{% end %}

                \{% if value["root"] %}
                  end
                \{% end %}

              \{% if value["nilable"] || value["default"] != nil %} } \{% end %}

          \{% end %}
          else
            \{% if strict %}
              raise ::JSON::ParseException.new("Unknown json attribute: #{key}", 0, 0)
            \{% else %}
              %pull.skip
            \{% end %}
          end
        end

        \{% for key, value in INHERITABLE_JSON_MAPPING %}
          \{% if !(value["nilable"] || value["default"] != nil) %}
            if %var\{key.id}.nil? && !%found\{key.id} && !::Union(\{{value["type"]}}).nilable?
              raise ::JSON::ParseException.new("Missing json attribute: \{{(value[:key] || key).id}}", 0, 0)
            end
          \{% end %}
        \{% end %}

        \{% for key, value in INHERITABLE_JSON_MAPPING %}
          \{% if value["nilable"] %}
            \{% if value["default"] != nil %}
              @\{{key.id}} = %found\{key.id} ? %var\{key.id} : \{{value["default"]}}
            \{% else %}
              @\{{key.id}} = %var\{key.id}
            \{% end %}
          \{% elsif value["default"] != nil %}
            @\{{key.id}} = %var\{key.id}.nil? ? \{{value["default"]}} : %var\{key.id}
          \{% else %}
            @\{{key.id}} = (%var\{key.id}).as(\{{value["type"]}})
          \{% end %}
        \{% end %}
      end

      def to_json(json : ::JSON::Builder)
        json.object do
          \{% for key, value in INHERITABLE_JSON_MAPPING %}
            _\{{key.id}} = @\{{key.id}}

            \{% if !value["emit_null"] %}
              unless _\{{key.id}}.nil?
            \{% end %}

              json.field(\{{value["key"] || key}}) do
                \{% if value["root"] %}
                  \{% if value["emit_null"] %}
                    if _\{{key.id}}.nil?
                      nil.to_json(json)
                    else
                  \{% end %}

                  json.object do
                    json.field(\{{value["root"]}}) do
                \{% end %}

                \{% if value["converter"] %}
                  if _\{{key.id}}
                    \{{ value["converter"] }}.to_json(_\{{key.id}}, json)
                  else
                    nil.to_json(json)
                  end
                \{% else %}
                  _\{{key.id}}.to_json(json)
                \{% end %}

                \{% if value["root"] %}
                  \{% if value["emit_null"] %}
                    end
                  \{% end %}
                    end
                  end
                \{% end %}
              end

            \{% if !value["emit_null"] %}
              end
            \{% end %}
          \{% end %}
        end
      end
    end

    # This is a convenience method to allow invoking `JSON.mapping`
    # with named arguments instead of with a hash/named-tuple literal.
    macro mapping(**properties)
      mapping(\{{properties}})
    end
  end
end
