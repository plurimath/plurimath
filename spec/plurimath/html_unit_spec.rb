require "spec_helper"

RSpec.describe "HTML writer for units" do
  def html(text)
    Plurimath::Math.parse(%("unitsml(#{text})"), :asciimath).to_html
  end

  it "sets a unit upright without an exponent" do
    expect(html("m")).to eq("m")
  end

  it "sets a unit upright with an exponent" do
    expect(html("m^2")).to eq("m<sup>2</sup>")
    expect(html("m*s^-2")).to eq("m &#x22c5; s<sup>&#x2212; 2</sup>")
  end

  it "still sets an ordinary variable italic" do
    expect(Plurimath::Math.parse("x^2", :asciimath).to_html)
      .to eq("<i>x</i><sup>2</sup>")
  end
end
