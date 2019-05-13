require "../spec_helper"
require "../../src/ifrit/hash_with_indifferent_access"

describe HashWithIndifferentAccess do
  describe "::new" do
    context "without arguemnts" do
      it "creates empty object" do
        HashWithIndifferentAccess(String).new.empty?.should be_true
      end
    end

    context "from string based hash" do
      it "copies all key-value pairs" do
        hash = {"k1" => 1, "k2" => 2}
        subject = HashWithIndifferentAccess(Int32).new(hash)
        subject["k1"].should eq(1)
        subject["k2"].should eq(2)
      end
    end

    context "from symbol based hash" do
      it "copies all key-value pairs" do
        hash = {:k1 => "1", :k2 => "2"}
        subject = HashWithIndifferentAccess(String).new(hash)
        subject[:k1].should eq("1")
        subject[:k2].should eq("2")
      end
    end

    context "from named tuple" do
      it "copies all key-value pairs" do
        tuple = {k1: 1, k2: "2"}
        subject = HashWithIndifferentAccess(String | Int32).new(tuple)
        subject["k1"].should eq(1)
        subject["k2"].should eq("2")
      end
    end
  end

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
