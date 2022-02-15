require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Asciimath::Function::Cancel do

  it 'returns instance of Cancel' do
    cancel = Plurimath::Asciimath::Function::Cancel.new('70')
    expect(cancel).to be_a(Plurimath::Asciimath::Function::Cancel)
  end

  it 'initializes Cancel object' do
    cancel = Plurimath::Asciimath::Function::Cancel.new('70')
    expect(cancel.value).to eql('70')
  end
end

