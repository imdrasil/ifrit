require "../spec_helper"
require "bit_array"
require "../../src/ifrit/core"

describe "Core" do
  describe "#blank?" do
    it "true" do
      ([] of String).blank?.should eq(true)
      ({} of String => String).blank?.should eq(true)
      nil.blank?.should eq(true)
      BitArray.new(0).blank?.should eq(true)
      BitArray.new(3).blank?.should eq(true)
      Tuple.new.blank?.should eq(true)
      NamedTuple.new.blank?.should eq(true)
    end

    it "false" do
      [1].blank?.should eq(false)
      {"a" => 1}.blank?.should eq(false)
      1.blank?.should eq(false)
      false.blank?.should eq(false)
      array = BitArray.new(3)
      array[2] = true
      array.blank?.should eq(false)
      {1, "a"}.blank?.should eq(false)
      {a: 2}.blank?.should eq(false)
    end
  end
end
