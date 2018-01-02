module Ifrit
  # Allows to pluralize values in compile-time.
  #
  # This is a port of [inflector.cr](https://github.com/phoffer/inflector.cr).
  module Inflector
    UNCOUNTABLE            = %w(equipment information rice money species series fish sheep jeans police)
    IRREGULAR_PLURAL_RULES = [
      [/person$/, "people"],
      [/man$/, "men"],
      [/child$/, "children"],
      [/sex$/, "sexes"],
      [/move$/, "moves"],
      [/zombie$/, "zombies"],
    ]

    IRREGULAR_SINGULAR_RULES = [
      [/people$/, "person"],
      [/men$/, "man"],
      [/children$/, "child"],
      [/sexes$/, "sex"],
      [/moves$/, "move"],
      [/zombies$/, "zombie"],
    ]

    PLURAL_RULES = [
      [/(quiz)$/i, "zes", /$/i],
      [/^(oxen)$/i, "oxen", /^(oxen)$/i],
      [/^(ox)$/i, "en", /$/i],
      [/^(m|l)ice$/i, "", /$/i],
      [/^(m|l)ouse$/i, "ice", /ouse$/i],
      [/(matr|vert|ind)(ix|ex)$/i, "ices", /(ix|ex)$/i],
      [/(x|ch|ss|sh)$/i, "es", /$/i],
      [/([^aeiouy]|qu)y$/i, "ies", /y$/i],
      [/(hive)$/i, "s", /$/i],
      [/([^f]fe)$/i, "ves", /fe$/i],
      [/([lr]f)$/i, "ves", /f$/i],
      [/sis$/i, "ses", /sis$/i],
      [/[ti]a$/i, "", /$/i],
      [/([ti])um$/i, "a", /um$/i],
      [/(buffal|tomat)o$/i, "es", /$/i],
      [/(bu)s$/i, "es", /$/],
      [/(alias|status)$/i, "es", /$/],
      [/(octop|vir)i$/i, "", /$/],
      [/(octop|vir)us$/i, "i", /us$/i],
      [/^(ax|test)is$/i, "es", /is$/i],
      [/s$/i, "s", /s$/i],
      [/$/, "s", /$/],
    ]

    SINGULAR_RULES = [
      [/(database)s$/i, "", /s$/i],
      [/(quiz)zes$/i, "", /zes$/i],
      [/(matr)ices$/i, "ix", /ices$/i],
      [/(vert|ind)ices$/i, "ex", /ices$/i],
      [/^(ox)en/i, "", /en$/i],
      [/(alias|status)(es)$/i, "", /es$/i],
      [/(octop|vir)(us|i)$/i, "us", /(us|i)$/i],
      [/^(a)x[ie]s$/i, "xis", /x[ie]s$/i],
      [/(cris|test)(is|es)$/i, "is", /(is|es)$/i],
      [/(shoe)s$/i, "", /s$/i],
      [/(o)es$/i, "", /es$/i],
      [/(bus)(es)$/i, "", /es$/i],
      [/^(m|l)ice$/i, "ouse", /ice$/i],
      [/(x|ch|ss|sh)es$/i, "", /es$/i],
      [/(m)ovies$/i, "ovie", /ovies$/i],
      [/(s)eries$/i, "eries", /eries$/i],
      [/([^aeiouy]|qu)ies$/i, "y", /ies$/i],
      [/([lr])ves$/i, "f", /ves$/i],
      [/(tive|hive)s$/i, "", /s$/i],
      [/([^f])ves$/i, "fe", /ves$/i],
      [/(^analy)(sis|ses)$/i, "sis", /(sis|ses)$/i],
      [/((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)(sis|ses)$/i, "sis", /(sis|ses)$/i],
      [/([ti])a$/i, "um", /a$/i],
      [/(n)ews$/i, "ews", /ews$/i],
      [/(ss)$/i, "", /$/],
      [/s$/i, "", /s$/],
    ]

    # Pluralize given string literal.
    macro pluralize(string)
      {% looking = true %}
      {% if !UNCOUNTABLE.includes?(string) %}
        {% for row in IRREGULAR_PLURAL_RULES %}
          {% if looking && string =~ row[0] %}
            {{string.gsub(row[0], row[1])}}
            {% looking = false %}
          {% end %}
        {% end %}
        {% if looking %}
          {% for row in PLURAL_RULES %}
            {% if looking == true %}
              {%
                matcher = row[0]
                repl = row[1]
                rule = row[2]
              %}
              {% if string =~ matcher %}
                {{string.gsub(rule, repl)}}
                {% looking = false %}
              {% end %}
            {% end %}
          {% end %}
        {% end %}
      {% else %}
        {{string}}
      {% end %}
    end

    # Singularize given string literal.
    macro singularize(string)
      {% looking = true %}
      {% if !UNCOUNTABLE.includes?(string) %}
        {% for row in IRREGULAR_SINGULAR_RULES %}
          {% if looking && string =~ row[0] %}
            {{string.gsub(row[0], row[1])}}
            {% looking = false %}
          {% end %}
        {% end %}
        {% if looking %}
          {% for row in SINGULAR_RULES %}
            {% if looking == true %}
              {%
                matcher = row[0]
                repl = row[1]
                rule = row[2]
              %}
              {% if string =~ matcher %}
                {{string.gsub(rule, repl)}}
                {% looking = false %}
              {% end %}
            {% end %}
          {% end %}
        {% end %}
      {% else %}
        {{string}}
      {% end %}
    end
  end
end
