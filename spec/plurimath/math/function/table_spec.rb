require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Table do
  describe ".initialize" do
    subject(:table) { described_class.new(table_values, "{", "}") }

    context "initialize Table object" do
      let(:table_values) { ["70"] }

      it "returns instance of Table" do
        expect(table).to be_a(described_class)
      end

      it "initializes Table object" do
        expect(table.value).to eql(["70"])
        expect(table.open_paren).to eq(Plurimath::Math::Symbols::Paren::Lcurly.new)
        expect(table.close_paren).to eq(Plurimath::Math::Symbols::Paren::Rcurly.new)
        expect(table.options).to eql({})
      end
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new([first_value]).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-table-28-1"

    it_behaves_like "shared renderer fixture", "function-table-45-1"

    it_behaves_like "shared renderer fixture", "function-table-59-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new([first_value])
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-table-91-1"

    it_behaves_like "shared renderer fixture", "function-table-114-1"

    it_behaves_like "shared renderer fixture", "function-table-139-1"
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new([first_value]).to_latex(options: {})
    end

    context "contains multiple rows" do
      subject(:formula) do
        described_class.new([first_value, first_value]).to_latex(options: {})
      end

      let(:first_value) do
        Plurimath::Math::Function::Tr.new([
                                            Plurimath::Math::Function::Td.new([
                                                                                Plurimath::Math::Symbols::Symbol.new("x"),
                                                                              ]),
                                            Plurimath::Math::Function::Td.new([
                                                                                Plurimath::Math::Symbols::Symbol.new("y"),
                                                                              ]),
                                          ])
      end

      it_behaves_like "shared renderer fixture", "function-table-201-1"

      it_behaves_like "shared renderer fixture", "function-table-205-1"

      it_behaves_like "shared renderer fixture", "function-table-215-1"
    end

    it_behaves_like "shared renderer fixture", "function-table-228-1"

    it_behaves_like "shared renderer fixture", "function-table-242-1"

    it_behaves_like "shared renderer fixture", "function-table-257-1"
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new([first_value]).to_html(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-table-285-1"

    it_behaves_like "shared renderer fixture", "function-table-319-1"
  end
end
