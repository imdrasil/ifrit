class HashWithIndifferentAccess(V) < Hash(String, V)
  def []=(key : Symbol, value : V)
    self.[key.to_s] = value
  end

  def [](key : Symbol)
    self[key.to_s]
  end

  def has_key?(key : Symbol)
    has_key?(key.to_s)
  end

  def values_at(*indexes : Symbol)
    indexes.map { |index| self[index.to_s] }
  end
end
