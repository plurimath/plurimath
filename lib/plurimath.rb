require "mml"
require "parslet"
require "htmlentities"

# Select an XML engine
require_relative "plurimath/xml_engine"

module Plurimath
  autoload :Asciimath, File.expand_path("plurimath/asciimath", __dir__)
  autoload :Cli, File.expand_path("plurimath/cli", __dir__) unless RUBY_ENGINE == "opal"
  autoload :Formatter, File.expand_path("plurimath/formatter", __dir__)
  autoload :Html, File.expand_path("plurimath/html", __dir__)
  autoload :Latex, File.expand_path("plurimath/latex", __dir__)
  autoload :ParseError, File.expand_path("plurimath/math", __dir__)
  autoload :InvalidTypeError, File.expand_path("plurimath/math", __dir__)
  autoload :Math, File.expand_path("plurimath/math", __dir__)
  autoload :Mathml, File.expand_path("plurimath/mathml", __dir__)
  autoload :NumberFormatter, File.expand_path("plurimath/number_formatter", __dir__)
  autoload :Omml, File.expand_path("plurimath/omml", __dir__)
  autoload :UnicodeMath, File.expand_path("plurimath/unicode_math", __dir__)
  autoload :Unitsml, File.expand_path("plurimath/unitsml", __dir__)
  autoload :Utility, File.expand_path("plurimath/utility", __dir__)
  autoload :XmlEngine, File.expand_path("plurimath/xml_engine", __dir__)
  autoload :Version, File.expand_path("plurimath/version", __dir__)

  def mml_adapter(adapter)
    require "lutaml/model"
    Mml::V4::Configuration.adapter = adapter unless Mml::V4::Configuration.adapter
  end

  module_function :mml_adapter
end

default_adapter =
  if RUBY_ENGINE == "opal"
    require_relative "plurimath/setup/oga"
    require_relative "plurimath/setup/opal"
    :oga
  elsif ENV["PLURIMATH_OGA"]
    require_relative "plurimath/setup/oga"
    :oga
  else
    require_relative "plurimath/setup/ox_engine"
    :ox
  end

Plurimath.mml_adapter(default_adapter)
