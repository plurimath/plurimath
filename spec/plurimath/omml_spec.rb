require "spec_helper"

RSpec.describe Plurimath::Omml do

  describe ".initialize" do
    subject(:omml) { described_class.new(string) }

    context "contains simple OMML value" do
      let(:string) { "<m:oMathPara><m:oMath><m:r><m:t>dy</m:t></m:r></m:oMath></m:oMathPara>" }

      it 'returns instance of Omml' do
        expect(omml).to be_a(Plurimath::Omml)
      end

      it 'returns Mathml instance' do
        expect(omml.text).to eql(string)
      end
    end
  end

  describe ".to_latex, to_mathml, to_asciimath" do
    subject(:formula) { described_class.new(string).to_formula }

    context "contains example #01" do
      let(:string) do
        <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:nary>
                <m:naryPr>
                  <m:limLoc m:val="subSup"/>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:naryPr>
                <m:sub>
                  <m:r>
                    <m:t>2</m:t>
                  </m:r>
                </m:sub>
                <m:sup>
                  <m:r>
                    <m:t>1</m:t>
                  </m:r>
                </m:sup>
                <m:e>
                  <m:r>
                    <m:t>3</m:t>
                  </m:r>
                </m:e>
              </m:nary>
            </m:oMath>
          </m:oMathPara>
        OMML
      end

      it 'returns parsed Asciimath to Formula' do
        latex = '\int_2^1{3}'
        asciimath = 'int_2^1 3'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <msubsup>
                <mo>&#x222b;</mo>
                <mn>2</mn>
                <mn>1</mn>
              </msubsup>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context 'converts characters to unicode example #02' do
      let(:input) do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" displaystyle="true">
            <mtext>α</mtext>
            <mtext>&#x3b1;</mtext>
            <mtext>&alpha;</mtext>
          </math>
        MATHML
      end

      let(:expected_output) do
        <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:r>
                <m:t>&#x3b1;</m:t>
              </m:r>
              <m:r>
                <m:t>&#x3b1;</m:t>
              </m:r>
              <m:r>
                <m:t>&#x3b1;</m:t>
              </m:r>
            </m:oMath>
          </m:oMathPara>
        OMML
      end

      it 'converts `alpha`, `α` to `&#x3b1;`' do
        formula = Plurimath::Math.parse(input, :mathml)
        expect(formula.to_omml).to eq(expected_output)
      end
    end

    context 'contains underline example #03' do
      let(:string) do
        <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:limLow>
                <m:limLowPr>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:limLowPr>
                <m:e>
                  <m:r>
                    <m:t>3</m:t>
                  </m:r>
                </m:e>
                <m:lim>
                  <m:r>
                    <m:t>&#x332;</m:t>
                  </m:r>
                </m:lim>
              </m:limLow>
            </m:oMath>
          </m:oMathPara>
        OMML
      end

      let(:expected_value) do
        <<~MATHML

          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <munder>
                <mn>3</mn>
                <mo>&#x332;</mo>
              </munder>
            </mstyle>
          </math>
        MATHML
      end

      it 'converts and matches OMML to MathML' do
        expect(formula.to_mathml).to eq(expected_value)
      end
    end
  end

  describe ".to_omml" do
    context 'converts characters to unicode example #02' do
      let(:input) do
        <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" displaystyle="true">
            <mtext>α</mtext>
            <mtext>&#x3b1;</mtext>
            <mtext>&alpha;</mtext>
          </math>
        MATHML
      end
      let(:expected_output) do
        <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:r>
                <m:t>&#x3b1;</m:t>
              </m:r>
              <m:r>
                <m:t>&#x3b1;</m:t>
              </m:r>
              <m:r>
                <m:t>&#x3b1;</m:t>
              </m:r>
            </m:oMath>
          </m:oMathPara>
        OMML
      end

      it 'converts `alpha`, `α` to `&#x3b1;`' do
        formula = Plurimath::Math.parse(input, :mathml)
        expect(formula.to_omml).to eq(expected_output)
      end
    end
  end
end
