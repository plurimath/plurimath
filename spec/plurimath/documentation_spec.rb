require "spec_helper"

RSpec.describe Plurimath::Documentation do
  # Build a named class that mixes in the module the way the real bases do,
  # with metadata set as real constants (const_set, not lexically-scoped block
  # locals). stub_const cleans each one up after the example.
  def documented_double(name, parent = nil, **constants)
    klass = parent ? Class.new(parent) : Class.new { extend Plurimath::Documentation }
    constants.each { |const_name, value| klass.const_set(const_name, value) }
    stub_const(name, klass)
  end

  let(:sample) do
    documented_double(
      "DocSample",
      CATALOG_TYPE: :ternary,
      DESCRIPTION: "A sample.",
      REFERENCE: "https://example.com/sample",
      EXAMPLE: -> { Plurimath::Math::Number.new("1") },
    )
  end

  let(:bare) { documented_double("BareSample") }

  describe ".catalog_name" do
    it "derives a lowercased, separator-free slug from the class name" do
      expect(sample.catalog_name).to eq("docsample")
      expect(Plurimath::Math::Function::Sum.catalog_name).to eq("sum")
      expect(Plurimath::Math::Function::PowerBase.catalog_name).to eq("powerbase")
    end
  end

  describe ".catalog_type" do
    it "returns the declared type" do
      expect(sample.catalog_type).to eq(:ternary)
    end

    it "is nil when none is declared" do
      expect(bare.catalog_type).to be_nil
    end
  end

  describe ".description and .reference" do
    it "return the class's own constants" do
      expect(sample.description).to eq("A sample.")
      expect(sample.reference).to eq("https://example.com/sample")
    end

    it "are nil when undeclared" do
      expect(bare.description).to be_nil
      expect(bare.reference).to be_nil
    end
  end

  describe "constant inheritance" do
    # CATALOG_TYPE is declared once on a base and read with inherit: true;
    # DESCRIPTION/REFERENCE/EXAMPLE are per-class and read own-only.
    let(:parent) do
      documented_double("ParentDoc", CATALOG_TYPE: :ternary, DESCRIPTION: "parent")
    end
    let(:child) { documented_double("ChildDoc", parent) }

    it "inherits the shared catalog_type but not the per-class description" do
      expect(child.catalog_type).to eq(:ternary)
      expect(child.description).to be_nil
    end
  end

  describe ".example_formula" do
    it "wraps the EXAMPLE result in a Formula" do
      expect(sample.example_formula).to be_a(Plurimath::Math::Formula)
    end

    it "builds a fresh object on each call" do
      expect(sample.example_formula).not_to be(sample.example_formula)
    end

    it "is nil when no EXAMPLE is declared" do
      expect(bare.example_formula).to be_nil
    end

    it "defers evaluation of the block until called" do
      # Defining a class whose EXAMPLE raises must not blow up; only calling does.
      boom = documented_double("BoomSample", EXAMPLE: -> { raise "too early" })
      expect { boom.example_formula }.to raise_error("too early")
    end
  end

  describe ".documented?" do
    it "requires a description, a reference and an example" do
      expect(sample.documented?).to be(true)
      expect(bare.documented?).to be(false)

      missing_reference = documented_double(
        "NoRef", DESCRIPTION: "x", EXAMPLE: -> { Plurimath::Math::Number.new("1") }
      )
      missing_example = documented_double(
        "NoExample", DESCRIPTION: "x", REFERENCE: "https://example.com"
      )
      missing_description = documented_double(
        "NoDesc", REFERENCE: "https://example.com",
                  EXAMPLE: -> { Plurimath::Math::Number.new("1") }
      )
      expect(missing_reference.documented?).to be(false)
      expect(missing_example.documented?).to be(false)
      expect(missing_description.documented?).to be(false)
    end
  end

  describe ".catalog_entry" do
    it "exposes the metadata plus all four renderings" do
      entry = sample.catalog_entry

      expect(entry.keys).to contain_exactly(
        "name", "type", "description", "reference",
        "asciimath", "latexmath", "mathml", "omml"
      )
      expect(entry["name"]).to eq("docsample")
      expect(entry["type"]).to eq("ternary")
      expect(entry["description"]).to eq("A sample.")
      expect(entry["reference"]).to eq("https://example.com/sample")
      expect(entry["asciimath"]).to eq("1")
    end
  end
end
