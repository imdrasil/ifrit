require "./version"

# Allows to access values by both `String` and `Symbol` key.
class HashWithIndifferentAccess(V) < Hash(String, V)
  def self.new(hash : Hash)
    new_hash = new
    hash.each do |key, value|
      new_hash[key.to_s] = value
    end
    new_hash
  end

  def self.new(named_tuple : NamedTuple)
    new_hash = new
    named_tuple.each do |key, value|
      new_hash[key.to_s] = value
    end
    new_hash
  end

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
