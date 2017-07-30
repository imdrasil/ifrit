require "./version"

class HashWithIndifferentAccess(V) < Hash(String, V)
  def []=(key : Symbol, value : V)
    self[key.to_s] = value
  end

  def values_at(*indexes : Symbol)
    indexes.map { |index| self[index.to_s] }
  end

  def delete(key : Symbol)
    delete(key.to_s)
  end

  def delete(key : Symbol, &block)
    delete(key.to_s) { |k| yield k }
  end

  protected def find_entry(key : Symbol)
    find_entry(key.to_s)
  end
end
