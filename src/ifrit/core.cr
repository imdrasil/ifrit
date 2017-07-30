require "./version"

class Object
  macro singleton_delegate(*methods, to)
    {% for m in method %}
      def self.{{m.id}}(*args, **opts)
        {{to[:to].id}}.{{m.id}}(*args, **opts)
      end
    {% end %}
  end

  def blank? : Bool
    false
  end

  def present?
    !blank?
  end
end

abstract struct Struct
  macro singleton_delegate(*methods, to)
    {% for m in method %}
      def self.{{m.id}}
        {{to[:to].id}}.{{m.id}}
      end
    {% end %}
  end

  def blank?
    false
  end

  def present?
    !blank?
  end
end

struct Nil
  def blank?
    true
  end
end

class Array(T)
  def blank?
    size == 0
  end
end

class Hash(K, V)
  def blank?
    size == 0
  end
end

struct BitArray
  def blank?
    flag = true
    size.times do |i|
      if self[i]
        flag = false
        break
      end
    end
    flag
  end
end

struct Tuple
  def blank?
    empty?
  end
end

struct NamedTuple
  def blank?
    empty?
  end
end

#
# to bool
#

class String
  def to_bool
    return true if self == true || self =~ (/^(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/^(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end

struct Number
  def to_bool
    return true if self == 1
    return false if self == 0
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end
