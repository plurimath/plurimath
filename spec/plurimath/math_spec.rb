require_relative '../../lib/plurimath/math'

RSpec.describe Plurimath::Math do

  it "raises error on wrong type" do
    expect{Plurimath::Math.parse("asdf", type: 'wrong_type')}.to raise_error(Plurimath::Math::Error)
  end
end
