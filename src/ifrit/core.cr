require "./version"

class Object
  # Defines class method delegation.
  #
  # ```
  # class A
  #   def self.method1
  #   end
  # end
  #
  # class B
  #   singleton_delegate :method1, to: A
  # end
  # ```
  macro singleton_delegate(*methods, to)
    {% for m in method %}
      def self.{{m.id}}(*args, **opts)
        {{to[:to].id}}.{{m.id}}(*args, **opts)
      end
    {% end %}
  end

  # Returns if object is *blank* one - empty (or whitespaced) string, empty array, empty hash, `nil` or `false`.
  def blank? : Bool
    false
  end

  # Returns if object is not *blank* one - empty (or whitespaced) string, empty array, empty hash, `nil` or `false`.
  def present?
    !blank?
  end
end

# Defines class method delegation.
#
# ```
# struct A
#   def self.method1
#   end
# end
#
# struct B
#   singleton_delegate :method1, to: A
# end
# ```
abstract struct Struct
  macro singleton_delegate(*methods, to)
    {% for m in method %}
      def self.{{m.id}}
        {{to[:to].id}}.{{m.id}}
      end
    {% end %}
  end

  # Returns if object is *blank* one - empty (or whitespaced) string, empty array, empty hash, `nil` or `false`.
  def blank?
    false
  end

  # Returns if object is not *blank* one - empty (or whitespaced) string, empty array, empty hash, `nil` or `false`.
  def present?
    !blank?
  end
end

struct Nil
  # Returns if object is *blank* one - empty (or whitespaced) string, empty array, empty hash, `nil` or `false`.
  def blank?
    true
  end
end

class Array(T)
  # Returns if object is *blank* one - empty (or whitespaced) string, empty array, empty hash, `nil` or `false`.
  def blank?
    size == 0
  end
end

class Hash(K, V)
  # Returns if object is *blank* one - empty (or whitespaced) string, empty array, empty hash, `nil` or `false`.
  def blank?
    size == 0
  end
end

struct BitArray
  # Returns if object is *blank* one - empty (or whitespaced) string, empty array, empty hash, `nil` or `false`.
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
  # Returns if object is *blank* one - empty (or whitespaced) string, empty array, empty hash, `nil` or `false`.
  def blank?
    empty?
  end
end

struct NamedTuple
  # Returns if object is *blank* one - empty (or whitespaced) string, empty array, empty hash, `nil` or `false`.
  def blank?
    empty?
  end
end

#
# to bool
#

class String
  # Converts to boolean based on text. If string has invalid format - `ArgumentError` will be raised.
  def to_bool
    return true if self == true || self =~ (/^(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/^(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end

struct Number
  # Converts to boolean based on value (`1` - `true`, `0` - `false`, `ArgumentError` otherwise).
  def to_bool
    return true if self == 1
    return false if self == 0
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end
