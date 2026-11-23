require "open3"
require "rbconfig"
require "json"

# Each probe starts cold; spec_helper has already exercised the parsers here.
RSpec.describe "Lazy parser dependencies", if: RUBY_ENGINE != "opal" do
  def dependency_probe(code)
    lib = File.expand_path("../../lib", __dir__)
    out, err, status = Open3.capture3(RbConfig.ruby, "-I#{lib}", "-e", code)
    expect(status).to be_success, err
    JSON.parse(out)
  end

  %w[Parslet Parsanol HTMLEntities].each do |name|
    it "defers #{name} until it is used" do
      result = dependency_probe(<<~RUBY)
        require "json"
        before = $LOADED_FEATURES.dup
        require "plurimath"
        pending = Object.autoload?(:#{name})
        features = $LOADED_FEATURES - before
        #{name}
        puts JSON.generate([pending, features.grep(%r{/(parslet|parsanol|htmlentities)(/|\.)}), Object.autoload?(:#{name})])
      RUBY
      expect(result).to eq([name.downcase, [], nil])
    end

    it "preserves #{name} when the host loaded it first" do
      result = dependency_probe(<<~RUBY)
        require "json"
        require "#{name.downcase}"
        original = #{name}
        require "plurimath"
        puts JSON.generate(original.equal?(#{name}))
      RUBY
      expect(result).to be(true)
    end
  end

  it "completes namespaces left by partial dependency loads" do
    result = dependency_probe(<<~'RUBY')
      require "json"
      require "parsanol/version"
      module Parslet; end
      class HTMLEntities; end
      originals = [Parslet, Parsanol, HTMLEntities]
      require "plurimath"
      formula = Plurimath::Math.parse("x^2", :asciimath)
      puts JSON.generate([originals == [Parslet, Parsanol, HTMLEntities], formula.to_latex])
    RUBY
    expect(result).to eq([true, "x^{2}"])
  end

  it "loads the parser dependencies on the first conversion" do
    result = dependency_probe(<<~'RUBY')
      require "json"
      require "plurimath"
      formula = Plurimath::Math.parse("x^2 + 3.14", :asciimath)
      puts JSON.generate([formula.to_latex, Object.autoload?(:Parslet), Object.autoload?(:Parsanol), Object.autoload?(:HTMLEntities)])
    RUBY
    expect(result).to eq(["x^{2} + 3.14", nil, nil, nil])
  end

  it "keeps the Parslet rejection type on the first invalid parse" do
    result = dependency_probe(<<~'RUBY')
      require "json"
      require "plurimath"
      begin
        Plurimath::Asciimath::Parser.new("a/").parse
      rescue Parslet::ParseFailed => error
        puts JSON.generate(error.class.name)
      end
    RUBY
    expect(result).to eq("Parslet::ParseFailed")
  end
end
