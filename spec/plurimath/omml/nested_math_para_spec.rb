# frozen_string_literal: true

require "spec_helper"

# The omml model reads an m:oMathPara nested inside m:oMath or an argument
# as CTOMathPara; it is read like the outer m:oMathPara.
RSpec.describe Plurimath::Omml::Translator do
  describe "nested m:oMathPara" do
    def read(body)
      Plurimath::Math.parse(
        "<m:oMathPara xmlns:m='http://schemas.openxmlformats.org/officeDocument/2006/math'>" \
        "<m:oMath>#{body}</m:oMath></m:oMathPara>",
        :omml,
      )
    end

    def run(text)
      "<m:r><m:t>#{text}</m:t></m:r>"
    end

    it "reads an m:oMathPara inside m:oMath as its content" do
      nested = read("#{run('a')}<m:oMathPara><m:oMath>#{run('b')}</m:oMath></m:oMathPara>")
      flat = read("#{run('a')}#{run('b')}")

      expect(nested.to_asciimath).to eq(flat.to_asciimath)
    end

    it "reads an m:oMathPara inside an argument as its content" do
      nested = read(
        "<m:sSup><m:e><m:oMathPara><m:oMath>#{run('x')}</m:oMath></m:oMathPara></m:e>" \
        "<m:sup>#{run('2')}</m:sup></m:sSup>",
      )

      flat = read("<m:sSup><m:e>#{run('x')}</m:e><m:sup>#{run('2')}</m:sup></m:sSup>")

      expect(nested.to_asciimath).to eq(flat.to_asciimath)
    end

    it "reads every m:oMath of a nested m:oMathPara" do
      nested = read(
        "<m:oMathPara><m:oMath>#{run('a')}</m:oMath>" \
        "<m:oMath>#{run('b')}</m:oMath></m:oMathPara>",
      )
      flat = read("#{run('a')}#{run('b')}")

      expect(nested.to_asciimath).to eq(flat.to_asciimath)
    end
  end
end
