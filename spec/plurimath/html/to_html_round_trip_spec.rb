# frozen_string_literal: true

require "spec_helper"

RSpec.describe Plurimath::Html::Parser do
  describe ".parse" do
    subject(:formula) do
      described_class.new(html).parse
    end

    let(:formula_class) { Plurimath::Math::Formula }
    let(:html) { exp.to_html.gsub(/\s/, "") }
    let(:number_value) { Plurimath::Math::Number.new("2") }
    let(:text_value) { Plurimath::Math::Function::Text.new("x") }

    context "contains sqrt function output" do
      let(:exp) do
        formula_class.new([
                            Plurimath::Math::Function::Sqrt.new(text_value),
                          ])
      end

      it "round-trips the Formula to HTML output" do
        expect(formula).to eq(exp)
      end
    end

    context "contains sum function output" do
      let(:exp) do
        formula_class.new([
                            Plurimath::Math::Function::Sum.new(
                              text_value,
                              number_value,
                            ),
                          ])
      end

      it "round-trips the Formula to HTML output" do
        expect(formula).to eq(exp)
      end
    end

    context "contains lim function output" do
      let(:exp) do
        formula_class.new([
                            Plurimath::Math::Function::Lim.new(
                              text_value,
                              number_value,
                            ),
                          ])
      end

      it "round-trips the Formula to HTML output" do
        expect(formula).to eq(exp)
      end
    end

    context "contains mod function output" do
      let(:exp) do
        formula_class.new([
                            Plurimath::Math::Function::Mod.new(
                              text_value,
                              number_value,
                            ),
                          ])
      end

      it "round-trips the Formula to HTML output" do
        expect(formula).to eq(exp)
      end
    end

    context "contains linebreak function output" do
      let(:exp) do
        formula_class.new([
                            Plurimath::Math::Function::Linebreak.new,
                          ])
      end

      it "round-trips the Formula to HTML output" do
        expect(formula).to eq(exp)
      end
    end

    context "contains table function output" do
      let(:exp) do
        formula_class.new([
                            Plurimath::Math::Function::Table.new([
                                                                   Plurimath::Math::Function::Tr.new([
                                                                                                       Plurimath::Math::Function::Td.new([text_value]),
                                                                                                     ]),
                                                                 ]),
                          ])
      end

      it "round-trips the Formula to HTML output" do
        expect(formula).to eq(exp)
      end
    end

    context "contains pi symbol output" do
      let(:exp) do
        formula_class.new([
                            Plurimath::Math::Symbols::Pi.new,
                          ])
      end

      it "round-trips the Formula to HTML output" do
        expect(formula).to eq(exp)
      end
    end

    context "contains ceil function output" do
      let(:exp) do
        formula_class.new([
                            Plurimath::Math::Function::Ceil.new(text_value),
                          ])
      end

      it "parses to delimiter symbols because the HTML output is glyph-based" do
        expected_value = formula_class.new([
                                             Plurimath::Math::Symbols::Paren::Lceil.new,
                                             text_value,
                                             Plurimath::Math::Symbols::Paren::Rceil.new,
                                           ])

        expect(formula).to eq(expected_value)
      end
    end

    context "contains vec function output" do
      let(:exp) do
        formula_class.new([
                            Plurimath::Math::Function::Vec.new(text_value),
                          ])
      end

      it "parses to an arrow symbol because the HTML output is glyph-based" do
        expected_value = formula_class.new([
                                             Plurimath::Math::Symbols::Rightarrow.new,
                                             text_value,
                                           ])

        expect(formula).to eq(expected_value)
      end
    end
  end
end
