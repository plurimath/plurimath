require "open3"
require "rbconfig"
require "tempfile"
require_relative "../../scripts/measure_optional_stages"

# The probe starts cold children: spec_helper's already-loaded constants cannot
# hide a dependency crossing one of these optional-stage boundaries.
RSpec.describe MeasureOptionalStages, if: RUBY_ENGINE != "opal", engine_loop: :once do
  %w[ox oga].each do |engine|
    context "with #{engine}" do
      before(:context) do
        Tempfile.create(["optional-stages", ".json"]) do |file|
          expect(MeasureOptionalStages.call(["--engine", engine, "--output", file.path])).to eq(0)
          @stage_report = JSON.parse(File.read(file.path)).fetch("scenarios")
        end
      end

      let(:report) { @stage_report }

      it "keeps optional surfaces unloaded during a six-writer conversion" do
        expect(report.fetch("require").fetch("loaded_groups").values).to all(be(false))
        conversion = report.fetch("conversion")
        expect(conversion.fetch("loaded_groups").values).to all(be(false))
        expect(conversion.fetch("result").fetch("to_latex")).to eq("x^{2} + 3.14")
        expect(conversion.fetch("result").size).to eq(6)
      end

      it "uses catalog metadata and text formatting without loading the math facade" do
        catalog = report.fetch("catalog_metadata")
        expect(catalog.fetch("result").fetch("name")).to eq("alpha")
        expect(catalog.fetch("pending").fetch("Math")).not_to be_nil
        formatter = report.fetch("number_formatting")
        expect(formatter.fetch("result")).to eq("1,234,567.891")
        expect(formatter.fetch("pending").fetch("Math")).not_to be_nil
      end

      it "loads catalog documentation only when a class is documented" do
        catalog = report.fetch("catalog_examples")
        expect(catalog.fetch("loaded_groups").fetch("catalog_documentation")).to be(true)
        expect(catalog.fetch("result").fetch("symbol").fetch("latexmath")).to eq("\\alpha")
        expect(catalog.fetch("result").fetch("function").fetch("name")).to eq("sin")
        expect(catalog.fetch("violations")).to be_empty
      end

      it "dispatches the renderer without loading its native backend" do
        renderer = report.fetch("renderer_dispatch")
        expect(renderer.fetch("result")).to eq("svg")
        expect(renderer.fetch("loaded_groups").fetch("renderer")).to be(true)
        expect(renderer.fetch("loaded_groups").fetch("native_backend")).to be(false)
      end

      it "loads the intent stage only for an intent-enabled writer" do
        intent = report.fetch("intent_mathml")
        expect(intent.fetch("loaded_groups").fetch("intent_processing")).to be(true)
        expect(intent.fetch("result")).to include('intent=":derivative(1,f,x)"')
      end
    end
  end

  {
    "catalog" => "plurimath/catalog",
    "catalog_documentation" => "plurimath/documentation/catalog_methods",
    "intent_processing" => "plurimath/math/formula/intent_processing",
  }.each do |group, path|
    it "fails the gate when require eagerly loads #{group}" do
      Tempfile.create(["eager-stage", ".rb"]) do |preload|
        preload.write("require 'plurimath'; require '#{path}'")
        preload.flush
        Tempfile.create(["optional-stages", ".json"]) do |output|
          stdout, stderr, status = Open3.capture3(
            { "RUBYOPT" => "#{ENV['RUBYOPT']} -r#{preload.path}" },
            RbConfig.ruby, "-Ilib", "scripts/measure_optional_stages.rb",
            "--scenario", "require", "--output", output.path,
            chdir: described_class::ROOT,
          )
          expect(status.exitstatus).to eq(1), "#{stdout}\n#{stderr}"
          data = JSON.parse(File.read(output.path))
          expect(data.dig("scenarios", "require", "violations")).to include(group)
        end
      end
    end
  end
end
