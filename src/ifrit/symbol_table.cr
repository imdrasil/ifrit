class SymbolTable
  class UnknownSymbol < Exception
  end

  module Methods
    macro s(symbol)
      begin
        {% if SymbolTable::SYM_HASH[symbol] == nil %}
          {% SymbolTable::SYM_HASH[symbol] = symbol.id.stringify %}
          {% SymbolTable::STR_HASH[SymbolTable::SYM_HASH[symbol]] = symbol %}
        {% end %}
        {{symbol}}
      end
    end
  end

  include Methods

  SYM_HASH = {} of Symbol => String
  STR_HASH = {} of String => Symbol

  def self.by_string(str)
    STR_HASH[str]
  rescue KeyError
    raise UnknownSymbol.new(str)
  end
end

class String
  def to_sym
    SymbolTable.by_string(self)
  end
end
