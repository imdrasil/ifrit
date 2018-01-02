require "../spec_helper"
require "../../src/ifrit/symbol_table"

include SymbolTable::Methods

describe SymbolTable do
  describe "%s" do
    it "stores symbol for both translation directions" do
      SymbolTable.s(:a)
      SymbolTable::STR_HASH["a"].should eq(:a)
      SymbolTable::SYM_HASH[:a].should eq("a")
    end

    it "allows to include macro on top level" do
      s(:asd)
      SymbolTable::STR_HASH["asd"].should eq(:asd)
      SymbolTable::SYM_HASH[:asd].should eq("asd")
    end
  end

  context "string" do
    describe "#to_sym" do
      it "returns symbol from table" do
        SymbolTable.s(:asd)
        "asd".to_sym.should eq(:asd)
      end

      it "raises UnknowSymbol error if there is no such symbol" do
        expect_raises(SymbolTable::UnknownSymbol) do
          "qwe".to_sym
        end
      end
    end
  end
end
