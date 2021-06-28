require "../spec_helper"
require "../../src/ifrit/inheritable_json"

private class A
  extend InheritableJSON

  json_mapping({
    a:               String,
    b:               {type: Int32},
    nillable_field1: {type: String?},
    nillable_field2: {type: String?},
  })

  def initialize(@a : String, @b : Int32, @nillable_field1 : String? = nil, @nillable_field2 : String? = nil)
  end
end

private class B < A
  def initialize
    initialize("asd", 2)
  end
end

private class C < B
  json_mapping({
    with_default: {type: String?, default: "default"},
  })

  def initialize
    initialize("asd", 2)
  end
end

private class JsonWithConverter < A
  json_mapping({
    date: {type: Time?, converter: Time::Format.new("%F")},
  })

  def initialize
    initialize("asd", 2)
  end
end

private class JsonWithKey < A
  json_mapping(
    with_key: {type: String, key: "some_key"}
  )

  def initialize
    initialize("asd", 2)
    @with_key = "qe"
  end
end

private class JsonWithConstructor
  extend InheritableJSON

  json_mapping(
    with_constructor: A
  )

  def initialize
    @with_constructor = A.new("asd", 2)
  end
end

private class JsonWithRoot
  extend InheritableJSON
  json_mapping(
    with_root: {type: String, root: "nested"}
  )

  def initialize
    @with_root = "qwe"
  end
end

describe InheritableJSON do
  describe "%mapping" do
    context "nilable" do
      it "doesn't render if nil" do
        a = A.new("asd", 2)
        a.to_json.should eq(%({"a":"asd","b":2}))
        a.nillable_field2 = "1"
        a.to_json.should eq(%({"a":"asd","b":2,"nillable_field2":"1"}))
      end
    end

    context "default" do
      it "test" do
        c = C.from_json(%({"a":"asd","b":2}))
        c.with_default.should eq("default")
      end

      it "serialize" do
        c = C.new
        c.to_json.should eq(%({"a":"asd","b":2}))
      end
    end

    context "format" do
      it "serialize" do
        c = JsonWithConverter.new
        c.date = Time.local(2000, 1, 13)
        c.to_json.should eq(%({"a":"asd","b":2,"date":"2000-01-13"}))
      end

      it "deserialize" do
        JsonWithConverter.from_json(%({"a":"asd","b":2,"date":"2000-01-13"})).date.should eq(Time.utc(2000, 1, 13))
      end
    end

    context "key" do
      it "serialize" do
        obj = JsonWithKey.new
        obj.to_json.should eq(%({"a":"asd","b":2,"some_key":"qe"}))
      end

      it "deserializer" do
        obj = JsonWithKey.from_json(%({"a":"asd","b":2,"some_key":"asd"}))
        obj.with_key.should eq("asd")
      end
    end

    context "root" do
      it "serialize" do
        obj = JsonWithRoot.new
        obj.to_json.should eq(%({"with_root":{"nested":"qwe"}}))
      end

      it "deserializer" do
        obj = JsonWithRoot.from_json(%({"with_root":{"nested":"zxc","b":2}}))
        obj.with_root.should eq("zxc")
      end
    end

    context "use_constructor" do
      it "serialize" do
        obj = JsonWithConstructor.new
        obj.to_json.should eq(%({"with_constructor":{"a":"asd","b":2}}))
      end

      it "deserializer" do
        obj = JsonWithConstructor.from_json(%({"with_constructor":{"a":"qwe","b":2}}))
        obj.with_constructor.a.should eq("qwe")
      end
    end
  end
end
