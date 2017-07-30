require "../spec_helper"
require "../../src/ifrit/hash_with_indifferent_access"

describe HashWithIndifferentAccess do
  describe "#[]=" do
    it "sets value" do
      h = HashWithIndifferentAccess(Int32).new
      h[:asd] = 23
      h["asd"].should eq(23)
    end
  end

  describe "#[]" do
    it "allows symbol" do
      h = HashWithIndifferentAccess(Int32).new
      h["asd"] = 0
      h[:asd].should eq(0)
    end
  end

  describe "#has_key?" do
    it "returns true for symbol key if string one exists" do
      h = HashWithIndifferentAccess(Int32).new
      h["asd"] = 0
      h.has_key?(:asd).should eq(true)
    end

    it "returns false for symbol key if string one is not exist" do
      h = HashWithIndifferentAccess(Int32).new
      h["asd"] = 0
      h.has_key?(:qwe).should eq(false)
    end
  end

  describe "#values_at" do
    it "returns valeus" do
      h = HashWithIndifferentAccess(Int32).new
      h["asd"] = 2
      h["qwe"] = 1
      h.values_at(:qwe, :asd).should eq({1, 2})
    end
  end
end
