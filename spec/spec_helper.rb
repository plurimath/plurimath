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

  config.around(:all) do |example|
    Plurimath.xml_engine = Plurimath::XmlEngine::Ox
    example.run
    Plurimath.xml_engine = Plurimath::XmlEngine::Oga
    example.run
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def unicode_encode_entities(string = nil)
  # Implements pre-processing to convert Unicode characters to Unicode codes for Unicode::Parse class.
  remove_prefix(string)
  string = if string.include?("#") && !string.match?(/"([^"]*(#|&#x23;|\\\\eqno)[^"]*[^"]*|[^"]*(#|&#x23;|\\\\eqno)[^"]*[^"]*)"/)
      string.gsub!(/✎\(.*(\#).*\)/) { |str| str.gsub!("#", ":d:") }
      splitted = string.split("#")
      splitted.first.gsub!(":d:", "#")
      @splitted = splitted.last if splitted.count > 1
      splitted.first
    else
      string
    end
  string = HTMLEntities.new.encode(string, :hexadecimal)
  string.gsub!(/\\u([\da-fA-F]{1,5})\w{0,5}/) { "&#x#{$1};" }
  string.gsub!(/&#x2af7;.*&#x2af8;/, "")
  string.gsub!("&#x26;", "&")
  string.gsub!("&#x22;", "\"")
  string.gsub!(/\\\\/, "\\")
  string.strip!
  string
end

def remove_prefix(string)
  string.delete_prefix!("1") || string.delete_prefix!("0")
  string
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
