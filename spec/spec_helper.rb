if RUBY_ENGINE != "opal"
  require "simplecov"
  SimpleCov.start do
    add_filter "/spec/"
  end

  require "bundler/setup"
end
require "plurimath"
require "plurimath/xml_engine/oga"
require "rspec/matchers"
if RUBY_ENGINE == "opal"
  require "oga"
else
  require "nokogiri"
end
require "equivalent-xml/rspec_matchers"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.around(:each) do |example|
    Plurimath.xml_engine = Plurimath::XmlEngine::Ox
    Mml::Configuration.adapter = :ox
    example.run
    Plurimath.xml_engine = Plurimath::XmlEngine::Oga
    Mml::Configuration.adapter = :oga
    example.run
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def dump_ox_nodes(nodes)
  Plurimath::Math::Core.new.dump_ox_nodes(nodes)
end

def unicode_encode_entities(string = nil)
  # Implements pre-processing to convert Unicode characters to Unicode codes for Unicode::Parse class.
  remove_prefix(string)
  string = if string.include?("#") && !string.match?(/"([^"]*(#|&#x23;|\\\\eqno)[^"]*[^"]*|[^"]*(#|&#x23;|\\\\eqno)[^"]*[^"]*)"/)
    string = string.gsub(/✎\(.*(\#).*\)/) { |str| str = str.gsub("#", ":d:") }
    splitted = string.split("#")
    splitted[0] = splitted.first.gsub(":d:", "#")
    @splitted = splitted.last if splitted.count > 1
    splitted.first
  else
    string
  end
  string = HTMLEntities.new.encode(string, :hexadecimal)
  string = string.gsub(/\\u([\da-fA-F]{1,5})\w{0,5}/) { "&#x#{$1};" }
  string = string.gsub(/&#x2af7;.*&#x2af8;/, "")
  string = string.gsub("&#x26;", "&")
  string = string.gsub("&#x22;", "\"")
  string = string.gsub(/\\\\/, "\\")
  string = string.strip
  string
end

def remove_prefix(string)
  string.delete_prefix!("1") || string.delete_prefix!("0")
  string
end

def unicodemath_tests
  file_content = File.read("submodules/unicodemath-tests/unicodemath_tests.yaml")
  YAML.safe_load(file_content, permitted_classes: [Time])["tests"]
end

def hp(*hash_values)
  hash_values.each do |hash_value|
    if hash_value.is_a?(Hash)
      puts JSON.pretty_generate(hash_value)
    else
      pp hash_value
    end
  end
end
