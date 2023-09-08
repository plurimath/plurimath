require_relative '../../lib/plurimath/math'

RSpec.describe Plurimath::Omml do
  it 'returns instance of Omml' do
    omml = Plurimath::Omml.new('<mrow><mo>(</mo><mi>a</mi><mo>+</mo><mi>b</mi><mo>)</mo></mrow>')
    expect(omml).to be_a(Plurimath::Omml)
  end

  it 'returns Mathml instance' do
    omml = Plurimath::Omml.new('<mrow><mo>(</mo><mi>a</mi><mo>+</mo><mi>b</mi><mo>)</mo></mrow>')
    expect(omml.text).to eql('<mrow><mo>(</mo><mi>a</mi><mo>+</mo><mi>b</mi><mo>)</mo></mrow>')
  end

  context 'converts characters to unicode' do
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
