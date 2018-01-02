require "../spec_helper"

private class Test
  extend Ifrit

  def method
    str_hash({"a" => 1}, String | Int32)
  end
end

describe "Converters" do
  describe "%typed_hash" do
    it "converts given HashLiteral to hash with given value types" do
      hash = Ifrit.typed_hash({"a" => 1, "b" => "asd"}, String, String | Int32)
      hash.is_a?(Hash(String, String | Int32)).should eq(true)
    end
  end

  describe "%sym_hash_cast" do
    pending "converts hash to given type" do
    end

    pending "converts named tuple to hash with given type" do
    end
  end

  describe "%str_hash_cast" do
  end

  describe "%typed_hash_cast" do
    it "converts hash to one with given types" do
      hash = {"asd" => 1, :asd => "asd"}
      Ifrit.typed_hash_cast(hash, String | Symbol, Int32 | String).is_a?(Hash(String | Symbol, Int32 | String)).should eq(true)
    end
  end

  describe "%sym_hash" do
    it "creates hash with given value type" do
      Ifrit.sym_hash({asd: "asd", q: 1}, String | Int32 | Float64).is_a?(Hash(Symbol, String | Int32 | Float64)).should eq(true)
    end
  end

  describe "%str_hash" do
    it "cast hash literal" do
      Ifrit.str_hash({"a" => 1}, String | Int32).is_a?(Hash(String, String | Int32)).should eq(true)
    end
  end

  describe "%typed_array_cast" do
    it "converts array variable to given type" do
      arr = [1, "asd"]
      Ifrit.typed_array_cast(arr, String | Int32 | Symbol).is_a?(Array(String | Int32 | Symbol)).should eq(true)
    end

    it "converts tuple to array" do
      arr = {1, "asd"}
      Ifrit.typed_array_cast(arr, String | Int32 | Symbol).is_a?(Array(String | Int32 | Symbol)).should eq(true)
    end
  end

  describe "%typed_array" do
    it "converts to array with given type" do
      Ifrit.typed_array([:asd, 1], String | Symbol | Int32).is_a?(Array(String | Symbol | Int32)).should eq(true)
    end
  end

  describe "%stringify_hash" do
    it "stringify named tuple literal" do
      Ifrit.stringify_hash({a: 1}, String | Int32).is_a?(Hash(String, String | Int32)).should eq(true)
    end
  end

  it "properly inherits macrosses" do
    Test.new.method.is_a?(Hash(String, String | Int32)).should eq(true)
  end
end
