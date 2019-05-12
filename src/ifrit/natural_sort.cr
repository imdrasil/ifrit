# NOTE: WIP
# module Ifrit
#   abstract class NaturalSort
#     class Segment
#       include Comparable(self)

#       @parts : Array()
#       def initialize(payload : String)
#         @parts
#       end

#       def <=>(other : self)

#     end

#     def self.sort(array : Array(String))
#       array.sort_by { |element| normalize(element) }
#     end

#     def self.normalize(element : String)
#       tokens = element.to_s.gsub(/\_/, "").scan(/\p{Word}+/)
#       tokens.map { |token| Segment.new(token) }
#     end
#   end
# end
