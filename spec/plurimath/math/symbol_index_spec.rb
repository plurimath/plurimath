# frozen_string_literal: true

require "open3"
require "rbconfig"

RSpec.describe Plurimath::Math::SymbolIndex do
  let(:root) { File.expand_path("../../..", __dir__) }

  it "matches the symbol classes (regenerate with scripts/generate_symbol_index.rb)" do
    _out, err, status = Open3.capture3(
      RbConfig.ruby, File.join(root, "scripts", "generate_symbol_index.rb"), "--check",
      chdir: root
    )
    expect(status.success?).to be(true), err
  end

  it "lists every symbol file under a constant" do
    dir = "#{root}/lib/plurimath/math/symbols/"
    files = Dir.glob("#{dir}**/*.rb").map { |f| f.delete_prefix(dir).delete_suffix(".rb") }
    indexed = described_class::FILES.values + described_class::PAREN_FILES.values + ["symbol"]

    expect(indexed).to match_array(files)
  end

  it "loads only the symbol classes a first parse uses" do
    script = <<~RUBY
      require "plurimath"
      Plurimath::Math.parse("\\\\alpha + x^2", :latex).to_mathml
      print $LOADED_FEATURES.count { |f| f.include?("plurimath/math/symbols/") }
    RUBY
    out, err, status = Open3.capture3(RbConfig.ruby, "-I", File.join(root, "lib"),
                                      "-e", script, chdir: root)

    expect(status.success?).to be(true), err
    expect(Integer(out)).to be < 50
  end
end
