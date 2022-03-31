require_relative '../../../../lib/plurimath/asciimath'

RSpec.describe Plurimath::Math::Function::Cancel do

  it 'returns instance of Cancel' do
    cancel = Plurimath::Math::Function::Cancel.new('70')
    expect(cancel).to be_a(Plurimath::Math::Function::Cancel)
  end

  it 'initializes Cancel object' do
    cancel = Plurimath::Math::Function::Cancel.new('70')
    expect(cancel.parameter_one).to eql('70')
  end
end
