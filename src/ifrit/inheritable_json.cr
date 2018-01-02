require "json"
require "./version"

# Allows to define class with JSON definition and allows inheritance.
module InheritableJSON
  macro extended
    INHERITABLE_JSON_MAPPING = {} of String => Hash(String, String)

    macro json_mapping(properties, strict = false, hook = false)
      \{% for key, value in properties %}
        \{% properties[key] = {type: value} unless value.is_a?(HashLiteral) || value.is_a?(NamedTupleLiteral) %}
        \{% str_key = key.id.stringify %}
        \{% for k1, v2 in properties[key] %}
          \{% if INHERITABLE_JSON_MAPPING[str_key] == nil %}
            \{% INHERITABLE_JSON_MAPPING[str_key] = {} of String => String %}
          \{% end %}
          \{% INHERITABLE_JSON_MAPPING[str_key][k1.id.stringify] = v2.stringify %}
        \{% end %}
        \{% if properties[key][:type].is_a?(Path) || properties[key][:type].is_a?(Generic) %}
          \{% INHERITABLE_JSON_MAPPING[str_key]["use_constructor"] = "true" %}
        \{% end %}
      \{% end %}

      \{% for key, value in properties %}
        @\{{key.id}} : \{{value["type"]}} \{{ (value["nilable"] ? "?" : "").id }}

        \{% if value["setter"] == nil ? true : value["setter"] %}
          def \{{key.id}}=(_\{{key.id}} : \{{value["type"]}} \{{ (value["nilable"] ? "?" : "").id }})
            @\{{key.id}} = _\{{key.id}}
          end
        \{% end %}

        \{% if value["getter"] == nil ? true : value["getter"] %}
          def \{{key.id}}
            @\{{key.id}}
          end
        \{% end %}
      \{% end %}

      \{{"InheritableJSON.render_methods(\{{@type}})".id}}
    end

    macro inherited
      INHERITABLE_JSON_MAPPING = {} of String => Hash(String, String)
      \\{% for k, v in @type.superclass.constant("INHERITABLE_JSON_MAPPING") %}
        \\{% INHERITABLE_JSON_MAPPING[k] = v %}
      \\{% end %}
    end

    # This is a convenience method to allow invoking `JSON.mapping`
    # with named arguments instead of with a hash/named-tuple literal.
    macro json_mapping(**properties)
      json_mapping(\{{properties}})
    end
  end

  macro render_methods(klass)
    {% definition = klass.constant("INHERITABLE_JSON_MAPPING") %}
    {% strict = false %}
    def initialize(%pull : ::JSON::PullParser)
      {% for key, value in definition %}
        %var{key.id} = nil
        %found{key.id} = false
      {% end %}

        %pull.read_object do |key|
          case key
          {% for key, value in definition %}
            when {{value["key"] != nil ? value["key"].id : key}}
              {% type = value["type"].id %}
              %found{key.id} = true

              %var{key.id} =
                {% if value["nilable"] == "true" || value["default"] != nil %} %pull.read_null_or { {% end %}

                {% if value["root"] %}
                  %pull.on_key!({{value["root"].id}}) do
                {% end %}

                {% if value["converter"] %}
                  {{value["converter"].id}}.from_json(%pull)
                {% elsif value["use_constructor"] == "true" %}
                  {{type}}.new(%pull)
                {% else %}
                  ::Union({{type}}).new(%pull)
                {% end %}

                {% if value["root"] %}
                  end
                {% end %}

                {% if value["nilable"] == "true" || value["default"] != nil %} } {% end %}

          {% end %}
          else
            {% if strict %}
              raise ::JSON::ParseException.new("Unknown json attribute: #{key}", 0, 0)
            {% else %}
              %pull.skip
            {% end %}
          end
        end

        {% for key, value in definition %}
          {% if !(value["nilable"] == "true" || value["default"] != nil) %}
            if %var{key.id}.nil? && !%found{key.id} && !::Union({{value["type"].id}}).nilable?
              raise ::JSON::ParseException.new("Missing json attribute: {{(value[:key] || key).id}}", 0, 0)
            end
          {% end %}
        {% end %}

        {% for key, value in definition %}
          {% if value["nilable"] == "true" %}
            {% if value["default"] != nil %}
              @{{key.id}} = %found{key.id} ? %var{key.id} : {{value["default"].id}}
            {% else %}
              @{{key.id}} = %var{key.id}
            {% end %}
          {% elsif value["default"] != nil %}
            @{{key.id}} = %var{key.id}.nil? ? {{value["default"].id}} : %var{key.id}
          {% else %}
            @{{key.id}} = (%var{key.id}).as({{value["type"].id}})
          {% end %}
        {% end %}
    end


    def to_json(json : ::JSON::Builder)
      json.object do
        {% for key, value in definition %}
          _{{key.id}} = @{{key.id}}

          {% if !value["emit_null"] %}
            unless _{{key.id}}.nil?
          {% end %}

            json.field({{value["key"] != nil ? value["key"].id : key}}) do
              {% if value["root"] %}
                {% if value["emit_null"] %}
                  if _{{key.id}}.nil?
                    nil.to_json(json)
                  else
                {% end %}

                json.object do
                  json.field({{value["root"].id}}) do
              {% end %}

              {% if value["converter"] %}
                if _{{key.id}}
                  {{ value["converter"].id }}.to_json(_{{key.id}}, json)
                else
                  nil.to_json(json)
                end
              {% else %}
                _{{key.id}}.to_json(json)
              {% end %}

              {% if value["root"] %}
                {% if value["emit_null"] %}
                  end
                {% end %}
                  end
                end
              {% end %}
            end

          {% if !value["emit_null"] %}
            end
          {% end %}
        {% end %}
      end
    end
  end
end
