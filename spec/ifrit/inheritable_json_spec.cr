require "../spec_helper"
require "../../src/ifrit/inheritable_json"

class A
  extend InheritableJSON

  mapping({
    a: String,
    b: Int32,
  })

  def initialize(@a, @b)
  end
end

describe HashWithIndifferentAccess do
  describe "%s" do
    it "stores symbol for both translation directions" do
      # puts A.from_json(%({"a": "asd", "b" 1})).inspect
      puts A.new("a", 1).to_json
    end
  end
end
