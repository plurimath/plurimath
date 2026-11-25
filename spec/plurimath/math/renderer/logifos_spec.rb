# frozen_string_literal: true

require "spec_helper"
require "logifos"

RSpec.describe Plurimath::Math::Renderer::Logifos do
  let(:library_path) do
    ENV.fetch("LOGIFOS_LIBRARY_PATH") do
      sibling_path("logifos-ruby/lib/logifos/native/#{Gem::Platform.local}/logifos.dylib")
    end
  end
  let(:font_path) do
    ENV.fetch("LOGIFOS_FONT") do
      sibling_path("logifos-rs/corpus/fonts/stix-two-math/STIXTwoMath-Regular.ttf")
    end
  end

  describe ".render" do
    it "requires the library path and the grading fonts up front" do
      expect { described_class.render("<math/>", format: :svg) }
        .to raise_error(ArgumentError, /requires :library_path/)
      expect { described_class.render("<math/>", format: :svg, library_path: "/nowhere") }
        .to raise_error(ArgumentError, /requires :fonts/)
    end

    it "wraps an unloadable native library as RenderingFailed" do
      expect { described_class.render("<math/>", format: :svg, library_path: "/nowhere", fonts: []) }
        .to raise_error(Plurimath::Errors::RenderingFailed)
    end

    context "with a native library and a grading font" do
      before do
        skip "no logifos native library available (set LOGIFOS_LIBRARY_PATH)" unless library_path && File.file?(library_path)
        skip "no grading font available (set LOGIFOS_FONT)" unless font_path && File.file?(font_path)
      end

      # Plurimath always serializes display/displaystyle on the math root,
      # and the engine's wire subset refuses them as unsupported classes
      # (WIRE_FAILED) until the wire carries the root layout hints. Pending
      # on that engine-side wire extension; the direct-runtime path renders
      # documents without those attributes today.
      it "renders a MathML document end to end", pending: "the engine wire subset refuses the root display hints plurimath serializes" do
        svg = render_logifos("<math><mi>x</mi></math>", format: :svg)

        expect(svg).to include("<svg")
        expect(svg).to include("viewBox")
      end
    end
  end

  def render_logifos(mathml, format:)
    fonts = [Logifos::NativeRuntime.font(id: "stix", bytes: File.binread(font_path))]
    Plurimath::Math.render(
      mathml,
      :mathml,
      format: format,
      engine: :logifos,
      library_path: library_path,
      fonts: fonts,
    )
  end

  def sibling_path(relative)
    candidate = File.expand_path("../../../../../../logifos/#{relative}", __dir__)
    candidate if File.file?(candidate)
  end
end
