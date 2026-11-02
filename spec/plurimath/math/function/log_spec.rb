require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Function::Log do
  describe ".initialize" do
    it "returns instance of Log" do
      log = described_class.new(7, 2)
      expect(log).to be_a(described_class)
    end

    it "initializes Log object" do
      log = described_class.new(70, 3)
      expect(log.parameter_one).to be(70)
      expect(log.parameter_two).to be(3)
    end
  end

  describe ".to_asciimath" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_asciimath(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-log-22-1"

    it_behaves_like "shared renderer fixture", "function-log-38-1"

    it_behaves_like "shared renderer fixture", "function-log-47-1"
  end

  describe ".to_mathml" do
    subject(:formula) do
      Plurimath.xml_engine.dump(
        described_class.new(first_value, second_value)
          .to_mathml_without_math_tag(false, options: {}),
        indent: 2,
      ).gsub("&amp;", "&")
    end

    it_behaves_like "shared renderer fixture", "function-log-80-1"

    it_behaves_like "shared renderer fixture", "function-log-109-1"

    it_behaves_like "shared renderer fixture", "function-log-125-1"
  end

  describe ".to_latex" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_latex(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-log-173-1"

    it_behaves_like "shared renderer fixture", "function-log-189-1"

    it_behaves_like "shared renderer fixture", "function-log-198-1"
  end

  describe ".to_html" do
    subject(:formula) do
      described_class.new(first_value, second_value).to_html(options: {})
    end

    it_behaves_like "shared renderer fixture", "function-log-227-1"

    it_behaves_like "shared renderer fixture", "function-log-243-1"

    it_behaves_like "shared renderer fixture", "function-log-252-1"
  end
end
