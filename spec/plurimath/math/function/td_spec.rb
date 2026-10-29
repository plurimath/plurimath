require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Td do
  describe ".initialize" do
    subject(:td) { described_class.new(first_value) }

    context "initialize Td object" do
      let(:first_value) { ["70"] }

      it "returns instance of Td" do
        expect(td).to be_a(described_class)
      end

      it "initialize Td object" do
        td = described_class.new(["70"])
        expect(td.parameter_one).to eql(["70"])
      end
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new([first_value]).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-td-26-1"

    it_behaves_like "shared renderer fixture", "function-td-34-1"

    it_behaves_like "shared renderer fixture", "function-td-42-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new([first_value])
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-td-67-1"

    it_behaves_like "shared renderer fixture", "function-td-80-1"

    it_behaves_like "shared renderer fixture", "function-td-93-1"
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new([first_value]).to_latex(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-td-125-1"

    # Regression: a leading Symbol whose value merely CONTAINS a pipe is not the
    # "|" column separator, so the cell renders its content instead of collapsing
    # to an empty string.
    it_behaves_like "shared renderer fixture", "function-td-136-1"

    it_behaves_like "shared renderer fixture", "function-td-144-1"

    it_behaves_like "shared renderer fixture", "function-td-152-1"
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new([first_value]).to_html(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-td-173-1"

    it_behaves_like "shared renderer fixture", "function-td-181-1"

    it_behaves_like "shared renderer fixture", "function-td-189-1"
  end
end
