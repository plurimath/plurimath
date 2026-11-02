require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Cancel do
  describe ".initialize" do
    it "returns instance of Cancel" do
      cancel = described_class.new("70")
      expect(cancel).to be_a(described_class)
    end

    it "initializes Cancel object" do
      cancel = described_class.new("70")
      expect(cancel.parameter_one).to eql("70")
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-cancel-21-1"

    it_behaves_like "shared renderer fixture", "function-cancel-29-1"

    it_behaves_like "shared renderer fixture", "function-cancel-37-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-cancel-62-1"

    it_behaves_like "shared renderer fixture", "function-cancel-75-1"

    it_behaves_like "shared renderer fixture", "function-cancel-88-1"
  end

  describe ".to_omml_without_math_tag" do
    let(:namespace) do
      { "m" => "http://schemas.openxmlformats.org/officeDocument/2006/math" }
    end
    let(:cancel) { described_class.new(first_value) }
    let(:document) do
      nodes = cancel.to_omml_without_math_tag(true, options: {})
      Oga.parse_xml("<root xmlns:m='#{namespace['m']}'>#{dump_ox_nodes(nodes)}</root>")
    end

    shared_examples "a diagonal cancellation" do
      it "preserves its argument identity after rendering" do
        document
        expect(cancel.parameter_one).to equal(first_value)
      end
    end

    context "with a symbol" do
      let(:first_value) { Plurimath::Math::Symbols::Symbol.new("n") }
      let(:expected_text) { ["n"] }

      it_behaves_like "a diagonal cancellation"
      it_behaves_like "shared renderer fixture", "function-cancel-1"
    end

    context "with a number" do
      let(:first_value) { Plurimath::Math::Number.new("70") }
      let(:expected_text) { ["70"] }

      it_behaves_like "a diagonal cancellation"
      it_behaves_like "shared renderer fixture", "function-cancel-2"
    end

    context "with a formula" do
      let(:first_value) { Plurimath::Math::Formula.new([Plurimath::Math::Number.new("70")]) }
      let(:expected_text) { ["70"] }

      it_behaves_like "a diagonal cancellation"
      it_behaves_like "shared renderer fixture", "function-cancel-3"
    end

    context "with an array containing an empty entry" do
      let(:first_value) do
        [Plurimath::Math::Symbols::Symbol.new("n"), nil, Plurimath::Math::Number.new("70")]
      end
      let(:expected_text) { ["n", "70"] }

      it_behaves_like "a diagonal cancellation"
      it_behaves_like "shared renderer fixture", "function-cancel-4"
    end

    context "with no argument" do
      let(:first_value) { nil }

      it_behaves_like "shared renderer fixture", "function-cancel-empty-5"
    end

    context "with an empty array" do
      let(:first_value) { [] }

      it_behaves_like "shared renderer fixture", "function-cancel-empty-6"
    end

    context "with another cancellation" do
      let(:first_value) { described_class.new(Plurimath::Math::Symbols::Symbol.new("n")) }
      let(:expected_text) { ["n"] }

      it_behaves_like "a diagonal cancellation"
      it_behaves_like "shared renderer fixture", "function-cancel-7"

      it_behaves_like "shared renderer fixture", "function-cancel-nested"
    end

    context "with an empty formula" do
      let(:first_value) { Plurimath::Math::Formula.new([]) }

      it_behaves_like "shared renderer fixture", "function-cancel-empty-8"
    end

    context "with an array containing an empty formula" do
      let(:first_value) { [Plurimath::Math::Formula.new([])] }

      it_behaves_like "shared renderer fixture", "function-cancel-empty-9"
    end

    context "with an empty nested cancellation" do
      let(:first_value) { described_class.new }

      it_behaves_like "shared renderer fixture", "function-cancel-empty-10"
    end
  end

  describe ".to_latex" do
    subject(:formula) { described_class.new(first_value).to_latex(options: {}) }

    it_behaves_like "shared renderer fixture", "function-cancel-226-1"

    it_behaves_like "shared renderer fixture", "function-cancel-234-1"

    it_behaves_like "shared renderer fixture", "function-cancel-242-1"
  end

  describe ".to_html" do
    subject(:formula) { described_class.new(first_value).to_html(options: {}) }

    it_behaves_like "shared renderer fixture", "function-cancel-261-1"

    it_behaves_like "shared renderer fixture", "function-cancel-269-1"

    it_behaves_like "shared renderer fixture", "function-cancel-277-1"
  end
end
