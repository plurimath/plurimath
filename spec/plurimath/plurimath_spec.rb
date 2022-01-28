require_relative '../../lib/plurimath/plurimath'

RSpec.describe Plurimath do

  testing_record = {
    unicode: {
      'M =
        \begin{bmatrix}
        -\sin λ_0 & \cos λ_0 & 0 \\
        -\sin φ_0 \cos λ_0 & -\sin φ_0 \sin λ_0 & \cos φ_0 \\
        \cos φ_0 \cos λ_0 & \cos φ_0 \sin λ_0 & \sin φ_0
        \end{bmatrix}': ['M =
        \begin{bmatrix}
        -\sin \lambda_0 & \cos \lambda_0 & 0 \\
        -\sin \varphi_0 \cos \lambda_0 & -\sin \varphi_0 \sin \lambda_0 & \cos \varphi_0 \\
        \cos \varphi_0 \cos \lambda_0 & \cos \varphi_0 \sin \lambda_0 & \sin \varphi_0
        \end{bmatrix}', :to_latex]
    },
    asciimath: {
      "rspec": ["#{
        <<~OUTPUT
        <?xml version=\"1.0\"?>\n<math xmlns=\"http://www.w3.org/1998/Math/MathML\">
          <mi>r</mi>\n  <mi>s</mi>\n  <mi>p</mi>\n  <mi>e</mi>\n  <mi>c</mi>\n</math>
        OUTPUT
        }", :to_unitsml]
    },
    omml: {
      "test.html": ["#{
        <<~OUTPUT
        <?xml version=\"1.0\"?>\n<!DOCTYPE html>\n<html xmlns:m=\"http://schemas.microsoft.com/office/2004/12/omml\">
        <head>\n  <meta charset=\"utf-8\"/>\n  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"/>
          <title>Test</title>\n</head>\n<body>\n  <h3>Rspec test case in progress</h3>\n</body>\n</html>
        OUTPUT
      }", :to_mathml]
    },
    mathml: {
      "<cn> 0 </cn>": ["<math xmlns=\"http://www.w3.org/1998/Math/MathML\"><cn> 0 </cn></math>", :to_asciimath]
    },
    html: {
      "<h3>rspec</h3>": ["\"rspec\"", :to_asciimath]
    },
    latex: {
      "rspec": ["#{<<~OUTPUT.gsub("\n", '')
        <math xmlns=\"http://www.w3.org/1998/Math/MathML\" display=\"block\"><mrow><mi>&#x00072;</mi><mi>&#x00073;
        </mi><mi>&#x00070;</mi><mi>&#x00065;</mi><mi>&#x00063;</mi></mrow></math>
        OUTPUT
      }",
        :to_mathml
      ]
    }
  }

  it 'Converts all entries successfully' do
    testing_record.each do |type, record|
      raw = record.keys[0].to_s
      converted = record.values.flatten[0]
      method_name = record.values.flatten[1]
      expect(Plurimath.parse(raw, type: type).send(method_name).text).to eql(converted)
    end
  end

  it "raises error on wrong type" do
    expect{Plurimath.parse("asdf", type: 'wrong_type')}.to raise_error(Plurimath::Error)
  end
end
