require "../spec_helper"
require "../../src/ifrit/hash_with_indifferent_access"

describe HashWithIndifferentAccess do
  describe "%s" do
    it "stores symbol for both translation directions" do
      h = HashWithIndifferentAccess(Int32).new
      h["asd"] = 23
      h["asd"].should eq(23)
    end
  end
end
