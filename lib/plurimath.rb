require "mml"
require "parslet"
require "htmlentities"

# Select an XML engine
require "plurimath/xml_engine"

module Plurimath
  autoload :Asciimath, "plurimath/asciimath"
  autoload :Cli, "plurimath/cli" unless RUBY_ENGINE == "opal"
  autoload :Formatter, "plurimath/formatter"
  autoload :Html, "plurimath/html"
  autoload :Latex, "plurimath/latex"
  autoload :ParseError, "plurimath/math"
  autoload :InvalidTypeError, "plurimath/math"
  autoload :Math, "plurimath/math"
  autoload :Mathml, "plurimath/mathml"
  autoload :NumberFormatter, "plurimath/number_formatter"
  autoload :Omml, "plurimath/omml"
  autoload :UnicodeMath, "plurimath/unicode_math"
  autoload :Unitsml, "plurimath/unitsml"
  autoload :Utility, "plurimath/utility"
  autoload :XmlEngine, "plurimath/xml_engine"
  autoload :Version, "plurimath/version"

  def mml_adapter(adapter)
    require "lutaml/model"
    Mml::V4::Configuration.adapter = adapter unless Mml::V4::Configuration.adapter
  end

  module_function :mml_adapter
end

default_adapter =
  if RUBY_ENGINE == "opal"
    require "plurimath/setup/oga"
    require "plurimath/setup/opal"
    :oga
  elsif ENV["PLURIMATH_OGA"]
    require "plurimath/setup/oga"
    :oga
  else
    require "plurimath/setup/ox_engine"
    :ox
  end

Plurimath.mml_adapter(default_adapter)
