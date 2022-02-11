require_relative '../../lib/plurimath/plurimath'

RSpec.describe Plurimath do

  it "raises error on wrong type" do
    expect{Plurimath.parse("asdf", type: 'wrong_type')}.to raise_error(Plurimath::Error)
  end
end
