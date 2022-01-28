require_relative '../../../lib/plurimath/plurimath'

RSpec.describe Omml do

  it 'returns instance of Omml' do
    expect(Omml.new('test.html')).to be_a(Omml)
  end

  it 'returns Mathml instance' do
    expect(Omml.new('test.html').to_mathml).to be_a(Mathml)
  end

  it 'converts Omml to mathml' do
    converted_str = <<~OUTPUT
                    <?xml version=\"1.0\"?>
                    <!DOCTYPE html>
                    <html xmlns:m=\"http://schemas.microsoft.com/office/2004/12/omml\">
                    <head>
                      <meta charset=\"utf-8\"/>
                      <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"/>
                      <title>Test</title>
                    </head>
                    <body>
                      <h3>Rspec test case in progress</h3>
                    </body>
                    </html>
                    OUTPUT
    expect(Omml.new('test.html').to_mathml.text).to eql(converted_str)
  end
end
