require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math do
  it_behaves_like "shared renderer fixture", "renderer-display-label-asciimath"
  it_behaves_like "shared renderer fixture", "renderer-display-label-latex"
  it_behaves_like "shared renderer fixture", "renderer-display-label-mathml"
  it_behaves_like "shared renderer fixture", "renderer-display-label-omml"
  it_behaves_like "shared renderer fixture", "renderer-display-label-unicodemath"

  describe ".to_display(:asciimath)" do
    subject(:formula) do
      described_class.parse(exp, :asciimath).to_display(:asciimath)
    end

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-35-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-54-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-70-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-116-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-132-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-156-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-175-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-198-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-221-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-236-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-251-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-266-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-293-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-323-1"
  end

  describe ".to_display(:mathml)" do
    subject(:formula) do
      described_class.parse(exp, :mathml).to_display(:mathml,
                                                     unary_function_spacing: false)
    end

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-342-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-379-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-413-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-515-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-546-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-597-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-635-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-689-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-741-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-767-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-793-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-818-1"
  end

  describe ".to_display(:OMML)" do
    subject(:formula) { described_class.parse(exp, :omml).to_display(:omml) }

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-872-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-941-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-1010-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-1239-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-1299-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-1426-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-1500-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-1629-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-1711-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-1753-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-1795-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-1818-1"
  end

  describe "AsciiMath input to all to_display(:lang) conversions" do
    subject(:formula) { described_class.parse(exp, :asciimath) }

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-1920-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-1976-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-2020-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-2178-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-2222-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-2298-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-2354-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-2426-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-2498-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-2538-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-2578-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-2617-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-2705-1"
  end

  describe "LaTeX input to all to_display(:lang) conversions" do
    subject(:formula) { described_class.parse(exp, :latex) }

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-2809-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-2865-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-2909-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-3067-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-3107-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-3175-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-3227-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-3291-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-3373-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-3413-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-3453-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-3492-1"
  end

  describe "MathML input to all to_display(:lang) conversions" do
    subject(:formula) { described_class.parse(exp, :mathml) }

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-3598-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-3672-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-3734-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-3948-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-4007-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-4110-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-4185-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-4288-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-4389-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-4440-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-4491-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-4540-1"
  end

  describe "UnicodeMath input to all to_display(:lang) conversions" do
    subject(:formula) { described_class.parse(exp, :unicode) }

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-4640-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-4708-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-4761-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-4934-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-4987-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-5080-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-5143-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-5226-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-5314-1"

    it_behaves_like "shared renderer fixture", "renderer-math_zone-math_zone-5362-1"
  end
end
