require "spec_helper"

# Characterization specs (phase A0 of the language-utility split).
#
# These examples pin the CURRENT behavior of the HTML-side sub/sup helper
# before it moves to a language-specific utility module. Expectations were
# derived by running the code, not from intent — oddities are pinned as-is
# and flagged with `# quirk:` comments rather than "fixed".
RSpec.describe Plurimath::Html::Utility do
  def number(value)
    Plurimath::Math::Number.new(value)
  end

  describe ".sub_sup_method?" do
    it "returns true for functions registered in Html SUB_SUP_CLASSES" do
      expect(described_class.sub_sup_method?(Plurimath::Math::Function::Log.new)).to be(true)
      expect(described_class.sub_sup_method?(Plurimath::Math::Function::Lim.new)).to be(true)
      expect(described_class.sub_sup_method?(Plurimath::Math::Function::Sum.new)).to be(true)
      expect(described_class.sub_sup_method?(Plurimath::Math::Function::Prod.new)).to be(true)
    end

    it "returns false for math objects outside SUB_SUP_CLASSES" do
      expect(described_class.sub_sup_method?(Plurimath::Math::Function::Sin.new)).to be(false)
      expect(described_class.sub_sup_method?(Plurimath::Math::Symbols::Symbol.new("x"))).to be(false)
      expect(described_class.sub_sup_method?(number("1"))).to be(false)
    end

    # quirk: objects without a #class_name method skip the check entirely,
    # so the method returns nil instead of false.
    it "returns nil for objects that do not respond to class_name" do
      expect(described_class.sub_sup_method?("plain string")).to be_nil
    end
  end
end
