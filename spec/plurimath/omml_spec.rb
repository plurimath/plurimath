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
        latex = '\int_{2}^{1} 3'
        asciimath = 'int_(2)^(1) 3'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <msubsup>
                  <mo>&#x222b;</mo>
                  <mn>2</mn>
                  <mn>1</mn>
                </msubsup>
                <mrow>
                  <mn>3</mn>
                </mrow>
              </mrow>
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
                <m:rPr>
                  <m:sty m:val="p"/>
                </m:rPr>
                <m:t>&#x3b1;</m:t>
              </m:r>
              <m:r>
                <m:rPr>
                  <m:sty m:val="p"/>
                </m:rPr>
                <m:t>&#x3b1;</m:t>
              </m:r>
              <m:r>
                <m:rPr>
                  <m:sty m:val="p"/>
                </m:rPr>
                <m:t>&#x3b1;</m:t>
              </m:r>
            </m:oMath>
          </m:oMathPara>
        OMML
      end

      it 'converts `alpha`, `α` to `&#x3b1;`' do
        skip "Lutaml::Model::XmlAdapter::Oga doesn't support HTML Entities yet!" if Lutaml::Model::Config.xml_adapter.type == "oga"
        formula = Plurimath::Math.parse(input, :mathml)
        expect(formula.to_omml).to eq(expected_output)
      end
    end

    context "contains nary munder example #03" do
      let(:string) do
        <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:nary>
                <m:naryPr>
                  <m:limLoc m:val="undOvr"/>
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
                <m:sup/>
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

      it 'converts and matches OMML to MathML' do
        latex = '\int_{2} 3'
        asciimath = 'int_(2) 3'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <munder>
                  <mo>&#x222b;</mo>
                  <mn>2</mn>
                </munder>
                <mrow>
                  <mn>3</mn>
                </mrow>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains nary msub example #04" do
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
                <m:sup/>
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
        latex = '\int_{2} 3'
        asciimath = 'int_(2) 3'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <msub>
                  <mo>&#x222b;</mo>
                  <mn>2</mn>
                </msub>
                <mrow>
                  <mn>3</mn>
                </mrow>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains nary mover example #05" do
      let(:string) do
        <<~OMML
          <m:oMathPara xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main" xmlns:mv="urn:schemas-microsoft-com:mac:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape">
            <m:oMath>
              <m:nary>
                <m:naryPr>
                  <m:limLoc m:val="undOvr"/>
                  <m:ctrlPr>
                    <w:rPr>
                      <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                      <w:i/>
                    </w:rPr>
                  </m:ctrlPr>
                </m:naryPr>
                <m:sub/>
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
        latex = '\int^{1} 3'
        asciimath = 'int^(1) 3'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <mover>
                  <mo>&#x222b;</mo>
                  <mn>1</mn>
                </mover>
                <mrow>
                  <mn>3</mn>
                </mrow>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains nary msup example #06" do
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
                <m:sub/>
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
        latex = '\int^{1} 3'
        asciimath = 'int^(1) 3'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mrow>
                <msup>
                  <mo>&#x222b;</mo>
                  <mn>1</mn>
                </msup>
                <mrow>
                  <mn>3</mn>
                </mrow>
              </mrow>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
      end
    end

    context "contains comment and overline example #07 from plurimath/plurimath#324" do
      let(:string) do
        <<~OMML
          <m:oMath xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math">
            <m:acc>
              <m:accPr>
                <m:chr m:val="‾"/> <!-- Overline character -->
              </m:accPr>
              <m:e>
                <m:r>
                  <m:t>AB</m:t>
                </m:r>
              </m:e>
            </m:acc>
          </m:oMath>
        OMML
      end

      it 'returns parsed Asciimath to Formula' do
        latex = '\overline{\text{AB}}'
        asciimath = 'bar("AB")'
        mathml = <<~MATHML
          <math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
            <mstyle displaystyle="true">
              <mover accent="true">
                <mtext>AB</mtext>
                <mo>&#xaf;</mo>
              </mover>
            </mstyle>
          </math>
        MATHML
        expect(formula.to_latex).to eq(latex)
        expect(formula.to_mathml).to be_equivalent_to(mathml)
        expect(formula.to_asciimath).to eq(asciimath)
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
                <m:rPr>
                  <m:sty m:val="p"/>
                </m:rPr>
                <m:t>&#x3b1;</m:t>
              </m:r>
              <m:r>
                <m:rPr>
                  <m:sty m:val="p"/>
                </m:rPr>
                <m:t>&#x3b1;</m:t>
              </m:r>
              <m:r>
                <m:rPr>
                  <m:sty m:val="p"/>
                </m:rPr>
                <m:t>&#x3b1;</m:t>
              </m:r>
            </m:oMath>
          </m:oMathPara>
        OMML
      end

      it 'converts `alpha`, `α` to `&#x3b1;`' do
        skip "Lutaml::Model::XmlAdapter::Oga doesn't support HTML Entities yet!" if Lutaml::Model::Config.xml_adapter.type == "oga"
        formula = Plurimath::Math.parse(input, :mathml)
        expect(formula.to_omml).to eq(expected_output)
      end
    end
  end
end
