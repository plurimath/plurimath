# frozen_string_literal: true

require "spec_helper"

# An uncertainty call (plurimath#493) placed wherever AsciiMath takes an
# operand. The amath grammar reaches `uncertainty` only through
# `symbol_text_or_integer`, so in every context it must build the tree a
# plain letter builds there, with the Uncertainty node in the letter's place.
# The unary rule splices its operand next to `unary_class`, so
# `sqrt ustd(1,2)` gives {unary_class:, uncertainty:} rather than a named
# operand; that shape once left a raw Hash in the Formula.
module AsciimathUncertaintyContexts
  UNCERTAINTY = "ustd(1,2)"
  PLACEHOLDER = "Q"
  FORMATS = %i[to_latex to_mathml to_asciimath to_unicodemath to_omml to_html].freeze

  CONTEXTS = [
    "frac U U", "frac U 2", "root U x", "root 2 U", "overset U x",
    "overset x U", "color(red) U", "U_x", "U!", "[[U]]", "[[U,U],[1,2]]",
    "(U)", "abs(U)", "U mod 3", "3 mod U", "U,U", "{U}", "obrace(U)",
    "lim_(U)", "sum_(i=1)^U", "sum_U^U", "int U dx", "-U", "U%", "a^U",
    "U^U", "a_U^U", "bb U", "bb(U)", "cancel U", "ul U", "vec U", "log_2 U",
    "f(U)", "sin(U)", "U = U", "left(U right)", "(U:)", "{:U:}", "U/U",
    "1/U", "U/1", "U \"unitsml(m)\"", "x ? U"
  ].freeze
  # Unary functions written without brackets: the spliced-operand shape.
  PREFIXED = %w[sqrt abs hat cancel ul vec ubrace obrace sin].map { "#{_1} U" }.freeze
end

RSpec.describe Plurimath::Asciimath do
  # Copies a formula tree, putting `replacement` wherever the placeholder
  # letter stands.
  def substitute(node, letter, replacement)
    case node
    when Plurimath::Math::Symbols::Symbol
      node.value == letter ? replacement : node
    when Array
      node.map { |item| substitute(item, letter, replacement) }
    when Plurimath::Math::Core
      node.dup.tap do |copy|
        copy.instance_variables.each do |name|
          next if name == :@input_string

          value = copy.instance_variable_get(name)
          copy.instance_variable_set(name, substitute(value, letter, replacement))
        end
      end
    else
      node
    end
  end

  def parse(text)
    Plurimath::Math.parse(text, :asciimath)
  end

  let(:uncertainty) { AsciimathUncertaintyContexts::UNCERTAINTY }
  let(:placeholder) { AsciimathUncertaintyContexts::PLACEHOLDER }
  let(:node) { parse(uncertainty).value.first }

  it "reads a bare call as one Uncertainty node" do
    expect(node).to be_a(Plurimath::Math::Function::Uncertainty)
  end

  (AsciimathUncertaintyContexts::CONTEXTS + AsciimathUncertaintyContexts::PREFIXED).each do |context|
    describe context.gsub("U", AsciimathUncertaintyContexts::UNCERTAINTY).inspect do
      let(:formula) { parse(context.gsub("U", uncertainty)) }

      AsciimathUncertaintyContexts::FORMATS.each do |format|
        it "renders #{format}" do
          expect { formula.public_send(format) }.not_to raise_error
        end
      end

      it "builds the same tree as a plain letter in its place" do
        letter_formula = parse(context.gsub("U", placeholder))
        expect(substitute(letter_formula, placeholder, node)).to eq(formula)
      end
    end
  end

  it "the tree comparison tells uncertainties apart" do
    letter_formula = parse("sqrt #{placeholder}")
    other = parse("ustd(1,3)").value.first
    expect(substitute(letter_formula, placeholder, other))
      .not_to eq(parse("sqrt #{uncertainty}"))
  end

  %w[sqrt abs hat cancel ul vec ubrace obrace].each do |function|
    it "reads #{function} ustd(1,2) as #{function}(ustd(1,2))" do
      expect(parse("#{function} #{uncertainty}"))
        .to eq(parse("#{function}(#{uncertainty})"))
    end
  end

  # sin keeps the brackets of sin(x), so it is compared with sin x above.
  it "keeps the uncertainty unbracketed in sin ustd(1,2)" do
    expect(parse("sin #{uncertainty}").value.first.parameter_one).to eq(node)
  end

  [
    "uexp(10.0, 0.3, 2)",
    "ucov(1.024, 0.983, 1.088, 0.95, shortest)",
    "ustd(1.230(4))",
    "ustd(1.23, 0.04, \"unitsml(m)\")",
  ].each do |call|
    it "reads sqrt #{call} as sqrt(#{call})" do
      expect(parse("sqrt #{call}")).to eq(parse("sqrt(#{call})"))
    end
  end

  describe Plurimath::Asciimath::Transform do
    it "rejects an uncertainty tree that no rule takes" do
      tree = {
        expr: {
          unknown_class: "sqrt",
          uncertainty: { uncertainty_class: "ustd", value: "1", magnitude: "2" },
        },
      }
      expect { described_class.new.apply(tree) }
        .to raise_error(Plurimath::Errors::InvalidUncertainty, /no AsciiMath rule/)
    end

    it "rejects a transformed Uncertainty node left inside an unmatched hash" do
      tree = {
        unknown: "x",
        value: { uncertainty: { uncertainty_class: "ustd", value: "1", magnitude: "2" } },
      }
      expect { described_class.new.apply(tree) }
        .to raise_error(Plurimath::Errors::InvalidUncertainty, /no AsciiMath rule/)
    end

    it "surfaces through Math.parse as a ParseError" do
      allow(Plurimath::Asciimath::Parse).to receive(:new).and_return(
        instance_double(
          Plurimath::Asciimath::Parse,
          parse: { unknown_class: "sqrt",
                   uncertainty: { uncertainty_class: "ustd", value: "1",
                                  magnitude: "2" } },
        ),
      )
      expect { parse("sqrt #{uncertainty}") }
        .to raise_error(Plurimath::Math::ParseError)
    end
  end
end
