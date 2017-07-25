class Object
  macro singleton_delegate(*methods, to)
    {% for m in method %}
      def self.{{m.id}}
        {{to[:to].id}}.{{m.id}}
      end
    {% end %}
  end

  macro alias_method(original_name, new_name)

  end

  macro alias_method_chain(original_name, suffix)


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
