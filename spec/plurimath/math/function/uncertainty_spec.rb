# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Math::Function::Uncertainty do
  def num(text)
    Plurimath::Math::Number.new(text)
  end

  def standard(value = "1.230", magnitude = "0.004", **options)
    described_class.new(num(value), category: :standard,
                                    magnitude: num(magnitude), **options)
  end

  def expanded(**options)
    described_class.new(num("10.0"), category: :expanded, magnitude: num("0.3"),
                                     coverage_factor: num("2"), **options)
  end

  def interval(**options)
    fields = { lower: num("0.983"), upper: num("1.088"),
               coverage_probability: num("0.95") }.merge(options)
    described_class.new(num("1.024"), category: :coverage_interval, **fields)
  end

  def unitsml(text)
    Plurimath::Math::Function::Unitsml.new(text)
  end

  let(:invalid) { Plurimath::Errors::InvalidUncertainty }
  let(:options) { {} }

  describe ".new" do
    it "is an InvalidUncertainty under Plurimath::Error" do
      expect(invalid.ancestors).to include(Plurimath::Error)
    end

    it "defaults a standard result to absolute notation" do
      expect(standard.notation).to eq(:absolute)
    end

    it "stores no notation on an expanded result" do
      expect(expanded.notation).to be_nil
      expect(expanded(notation: nil).notation).to be_nil
    end

    it "keeps the exact number text" do
      node = standard("1.230", "0.0040")
      expect([node.value.value, node.magnitude.value]).to eq(%w[1.230 0.0040])
    end

    it "accepts a negative value, a zero magnitude and integers" do
      expect { standard("-1.230", "0.000") }.not_to raise_error
      expect { standard("1234", "2") }.not_to raise_error
    end

    it "accepts a coverage probability and either interval kind" do
      expect { expanded(coverage_probability: num("0.95")) }.not_to raise_error
      expect { interval(interval_kind: :shortest) }.not_to raise_error
      expect { interval(interval_kind: :probabilistically_symmetric) }
        .not_to raise_error
    end

    it "accepts a Unitsml or a Formula unit" do
      expect { expanded(unit: unitsml("g")) }.not_to raise_error
      formula_unit = Plurimath::Math::Formula.new(
        [Plurimath::Math::Symbols::Symbol.new("g")],
      )
      expect { expanded(unit: formula_unit) }.not_to raise_error
    end

    it "does not require the value to lie inside the interval" do
      build = lambda do
        described_class.new(num("2.5"), category: :coverage_interval,
                                        lower: num("0.983"), upper: num("1.088"),
                                        coverage_probability: num("0.95"))
      end
      expect(&build).not_to raise_error
    end

    {
      "an unknown category" => -> { standard(category: :relative) },
      "a string category" => -> { standard(category: "standard") },
      "an unknown notation" => -> { standard(notation: :plain) },
      "a nil notation on a standard result" => -> { standard(notation: nil) },
      "a negative magnitude" => -> { standard("1.230", "-0.004") },
      "a signed positive magnitude" => -> { standard("1.230", "+0.004") },
      "an exponent" => -> { standard("1.230e-3", "0.004") },
      "a comma decimal marker" => -> { standard("1,230", "0,004") },
      "a trailing decimal point" => -> { standard("1.", "0.004") },
      "a missing magnitude" => lambda {
        described_class.new(num("1.230"), category: :standard)
      },
      "a non-Number value" => lambda {
        described_class.new(Plurimath::Math::Symbols::Symbol.new("x"),
                            category: :standard, magnitude: num("0.004"))
      },
      "a nil value" => lambda {
        described_class.new(nil, category: :standard, magnitude: num("0.004"))
      },
      "a based number" => lambda {
        described_class.new(Plurimath::Math::Number.new("10", base: 2),
                            category: :standard, magnitude: num("0.004"))
      },
      "a mini-sized number" => lambda {
        described_class.new(Plurimath::Math::Number.new("1", mini_sub_sized: true),
                            category: :standard, magnitude: num("0"))
      },
      "k on a standard result" => -> { standard(coverage_factor: num("1")) },
      "p on a standard result" => -> { standard(coverage_probability: num("0.68")) },
      "endpoints on a standard result" => -> { standard(lower: num("1")) },
      "an interval kind on a standard result" => -> { standard(interval_kind: :shortest) },
      "a concise magnitude with other decimal places" => lambda {
        standard("1.2", "0.004", notation: :concise)
      },
      "an expanded result without k" => lambda {
        described_class.new(num("10.0"), category: :expanded, magnitude: num("0.3"))
      },
      "k = 0" => lambda {
        described_class.new(num("10.0"), category: :expanded, magnitude: num("0.3"),
                                         coverage_factor: num("0.00"))
      },
      "p = 95" => -> { expanded(coverage_probability: num("95")) },
      "p = 1" => -> { expanded(coverage_probability: num("1.0")) },
      "p = 0" => -> { expanded(coverage_probability: num("0.0")) },
      "concise notation on an expanded result" => -> { expanded(notation: :concise) },
      "endpoints on an expanded result" => -> { expanded(upper: num("1")) },
      "an interval without p" => -> { interval(coverage_probability: nil) },
      "an interval with k" => -> { interval(coverage_factor: num("2")) },
      "an interval with a magnitude" => -> { interval(magnitude: num("0.1")) },
      "an interval with equal endpoints" => -> { interval(lower: num("1.0"), upper: num("1")) },
      "reversed endpoints" => -> { interval(lower: num("1.088"), upper: num("0.983")) },
      "reversed endpoints of different length" => -> { interval(lower: num("10"), upper: num("9.99")) },
      "a negative endpoint" => -> { interval(lower: num("-1")) },
      "an unknown interval kind" => -> { interval(interval_kind: :central) },
      "concise notation on an interval" => -> { interval(notation: :concise) },
      "a unit that is not Unitsml" => lambda {
        standard(unit: Plurimath::Math::Symbols::Symbol.new("g"))
      },
    }.each do |name, build|
      it "rejects #{name}" do
        expect { instance_exec(&build) }.to raise_error(invalid)
      end
    end
  end

  describe "#==" do
    it "is equal for the same fields" do
      expect(standard).to eq(standard("1.230", "0.004"))
      expect(interval(unit: unitsml("V")))
        .to eq(interval(lower: num("0.983"), unit: unitsml("V")))
    end

    it "compares notation" do
      expect(standard("1.23", "0.04", notation: :concise))
        .not_to eq(standard("1.23", "0.04"))
    end

    it "compares the exact number text" do
      expect(standard("1.230", "0.004")).not_to eq(standard("1.23", "0.004"))
    end

    it "tells standard and expanded results apart" do
      expect(standard("10.0", "0.3")).not_to eq(expanded)
    end

    it "compares p, the endpoints, the interval kind and the unit" do
      expect(expanded).not_to eq(expanded(coverage_probability: num("0.95")))
      expect(interval).not_to eq(interval(lower: num("0.984")))
      expect(interval).not_to eq(interval(upper: num("1.089")))
      expect(interval).not_to eq(interval(interval_kind: :shortest))
      expect(expanded(unit: unitsml("g"))).not_to eq(expanded(unit: unitsml("kg")))
      expect(expanded(unit: unitsml("g"))).not_to eq(expanded)
    end

    it "is not equal to another class" do
      expect(standard).not_to eq(num("1.230"))
    end
  end

  describe "#cloned_objects" do
    let(:node) do
      interval(interval_kind: :shortest, unit: unitsml("V"))
    end

    it "is equal to the original and shares no child objects" do
      clone = node.cloned_objects
      expect(clone).to eq(node)
      %i[value lower upper coverage_probability unit].each do |field|
        expect(clone.public_send(field)).not_to equal(node.public_send(field))
      end
    end

    it "does not change the original when the clone's children change" do
      clone = standard("1.23", "0.04", notation: :concise).cloned_objects
      clone.value.value = "9.99"
      expect(clone.value.value).to eq("9.99")
      expect(standard("1.23", "0.04", notation: :concise).value.value).to eq("1.23")
    end

    it "keeps concise notation and a Formula unit" do
      unit = Plurimath::Math::Formula.new([Plurimath::Math::Symbols::Symbol.new("g")])
      original = standard("1.23", "0.04", notation: :concise, unit: unit)
      clone = original.cloned_objects
      expect(clone).to eq(original)
      expect(clone.unit).not_to equal(unit)
    end
  end

  describe "#line_breaking" do
    it "leaves the node alone" do
      node = expanded(coverage_probability: num("0.95"))
      copy = node.cloned_objects
      obj = Plurimath::Math::Formula.new([])
      node.line_breaking(obj)
      expect(obj.value_exist?).to be(false)
      expect(node).to eq(copy)
    end
  end

  describe "#marker" do
    it "names each variant" do
      expect(standard.marker).to eq("standard-uncertainty(1.230,0.004)")
      expect(standard(notation: :concise).marker)
        .to eq("standard-uncertainty:concise(1.230,0.004)")
      expect(expanded(unit: unitsml("g")).marker)
        .to eq("expanded-uncertainty(10.0,0.3,2,$unit)")
      expect(interval.marker).to eq("coverage-interval(1.024,0.983,1.088,0.95)")
      expect(interval(interval_kind: :probabilistically_symmetric).marker)
        .to eq("coverage-interval:probabilistically-symmetric(1.024,0.983,1.088,0.95)")
    end
  end

  describe "concise digits" do
    {
      %w[100.02147 0.00035] => "35",
      %w[1234.5 2.0] => "20",
      %w[1.230 0.004] => "4",
      %w[1234 2] => "2",
      %w[1.23 0.00] => "0",
    }.each do |(value, magnitude), digits|
      it "writes #{value} with #{magnitude} as #{value}(#{digits})" do
        node = standard(value, magnitude, notation: :concise)
        expect(node.to_latex(options: options)).to eq("#{value}(#{digits})")
      end
    end
  end

  describe "direct output" do
    let(:node) { expanded(coverage_probability: num("0.95"), unit: unitsml("g")) }

    it "writes text formats" do
      expect(node.to_asciimath(options: options))
        .to eq('uexp(10.0, 0.3, 2, 0.95, "unitsml(g)")')
      expect(node.to_latex(options: options))
        .to eq("(10.0 \\pm 0.3) \\mathrm{g},\\ k = 2,\\ p = 0.95")
      expect(node.to_html(options: options))
        .to eq("(10.0 &#xb1; 0.3) g, k = 2, p = 0.95")
      expect(node.to_unicodemath(options: options)).to eq(
        "ⓘ(\"expanded-uncertainty(10.0,0.3,2,0.95,$unit)\"" \
        "(10.0±0.3)ⓐ(unit \\mupg), k=2, p=0.95)",
      )
    end

    it "writes the marker as intent whatever the intent option is" do
      [true, false].each do |intent|
        mathml = node.to_mathml_without_math_tag(intent, options: options)
        expect(mathml.name).to eq("mrow")
        expect(mathml["intent"]).to eq(node.marker)
      end
    end

    it "writes one OMML box led by the hidden marker" do
      omml = dump_ox_nodes(node.to_omml_without_math_tag(true, options: options))
      expect(omml).to start_with("<m:box>")
      expect(omml).to include("<m:show m:val=\"off\"/>")
      expect(omml).to include("<m:t>#{node.marker}</m:t>")
    end

    it "ignores the number formatter" do
      formatter = Plurimath::Formatter::Standard.new(
        options: { decimal: ",", significant: 1 },
      )
      formula = Plurimath::Math::Formula.new([standard("1.230", "0.004")])
      expect(formula.to_latex(formatter: formatter)).to eq("1.230(0.004)")
      expect(formula.to_asciimath(formatter: formatter)).to eq("ustd(1.230, 0.004)")
    end

    it "writes a standard result with a unit after the parentheses" do
      node = standard(unit: unitsml("g"))
      expect(node.to_asciimath(options: options))
        .to eq('ustd(1.230, 0.004, "unitsml(g)")')
      expect(node.to_latex(options: options)).to eq("1.230(0.004) \\mathrm{g}")
      expect(node.to_html(options: options)).to eq("1.230(0.004) g")
    end

    it "writes an interval with a unit after the brackets and no stated kind" do
      node = interval(unit: unitsml("V"))
      expect(node.to_asciimath(options: options))
        .to eq('ucov(1.024, 0.983, 1.088, 0.95, "unitsml(V)")')
      expect(node.to_latex(options: options))
        .to eq("1.024,\\ [0.983, 1.088] \\mathrm{V},\\ p = 0.95")
      expect(node.to_unicodemath(options: options)).to eq(
        "ⓘ(\"coverage-interval(1.024,0.983,1.088,0.95,$unit)\"" \
        "1.024, [0.983, 1.088]ⓐ(unit \\mupV), p=0.95)",
      )
    end

    it "writes the symmetric interval kind" do
      node = interval(interval_kind: :probabilistically_symmetric)
      expect(node.to_asciimath(options: options))
        .to eq("ucov(1.024, 0.983, 1.088, 0.95, symmetric)")
    end
  end
end
