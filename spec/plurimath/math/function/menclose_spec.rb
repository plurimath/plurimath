# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Math::Function::Menclose, engine_loop: :always do
  def enclosure(notation, content = Plurimath::Math::Symbols::Symbol.new("x"))
    described_class.new(notation, content)
  end

  it "writes the box notation as a LaTeX box" do
    expect(enclosure("box").to_latex(options: {})).to eq('\\boxed{x}')
  end

  it "keeps a compound boxed argument" do
    content = Plurimath::Math::Formula.new([
      Plurimath::Math::Symbols::Symbol.new("x"),
      Plurimath::Math::Number.new("2"),
    ])
    expect(enclosure("box", content).to_latex(options: {})).to eq('\\boxed{x 2}')
  end

  it "refuses the box notation in AsciiMath, whose parser has no box function" do
    expect { enclosure("box").to_asciimath(options: {}) }
      .to raise_error(Plurimath::Error, /Unsupported AsciiMath enclosure.*box/)
  end

  %w[circle roundedbox top bottom left right updiagonalstrike longdiv radical].each do |notation|
    %i[latex asciimath].each do |format|
      it "explicitly refuses #{notation} in #{format}" do
        expect { enclosure(notation).public_send("to_#{format}", options: {}) }
          .to raise_error(Plurimath::Error, /Unsupported .* enclosure/)
      end
    end
  end

  it "refuses a combination of notations rather than losing part of it" do
    expect { enclosure("box circle").to_latex(options: {}) }
      .to raise_error(Plurimath::Error, /box circle/)
  end

  it "keeps an empty box explicit" do
    expect(enclosure("box", nil).to_latex(options: {})).to eq('\\boxed{}')
  end

  it "preserves the existing MathML and OMML box" do
    node = enclosure("box")
    expect(node.to_mathml_without_math_tag(false, options: {})["notation"]).to eq("box")
    expect(node.to_omml_without_math_tag(true, options: {}).first.name).to eq("m:borderBox")
  end
end
