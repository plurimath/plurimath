# mml (and lutaml-model, moxml, leptris under it) is loaded on first
# MathML, OMML or UnitsML use; see Plurimath.load_mml.
autoload :Mml, "mml"
autoload :Lutaml, "lutaml/model"
require "parslet"
require "parsanol"
require "htmlentities"

# Select an XML engine
require "plurimath/xml_engine"

module Plurimath
  autoload :Asciimath, "plurimath/asciimath"
  autoload :Pma, "plurimath/pma"
  autoload :BaseNumberPrefix, "plurimath/base_number_prefix"
  autoload :Catalog, "plurimath/catalog"
  autoload :Cli, "plurimath/cli" unless RUBY_ENGINE == "opal"
  autoload :Configuration, "plurimath/configuration"
  autoload :Deprecation, "plurimath/deprecation"
  autoload :Documentation, "plurimath/documentation"
  autoload :SymbolDocumentation, "plurimath/symbol_documentation"
  autoload :Error, "plurimath/errors/error"
  autoload :ConfigurationError, "plurimath/errors/configuration_error"
  autoload :DeprecationError, "plurimath/errors/deprecation_error"
  autoload :Errors, "plurimath/errors"
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
  autoload :XmlHelper, "plurimath/xml_helper"
  autoload :Version, "plurimath/version"

  def mml_adapter(adapter)
    require "lutaml/model"
    require "mml"
    # The adapter chosen at require time is applied first, so it still wins
    # over a later call, as it did when it was set eagerly.
    if (default = @default_mml_adapter)
      @default_mml_adapter = nil
      Mml::V4::Configuration.adapter = default unless Mml::V4::Configuration.adapter
    end
    Mml::V4::Configuration.adapter = adapter unless Mml::V4::Configuration.adapter
  end

  # Records the adapter to set once mml is loaded, without loading it now.
  def default_mml_adapter=(adapter)
    @default_mml_adapter = adapter
  end

  # Loads mml and applies the default adapter. Called by the stages that
  # parse or write XML through lutaml-model (MathML, OMML, UnitsML).
  def load_mml
    return if @mml_loaded

    mml_adapter(nil)
    @mml_loaded = true
  end

  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    yield(configuration)
  end

  def with_configuration
    # Swap the global config to an isolated copy so block mutations are scoped.
    previous_configuration = configuration
    @configuration = previous_configuration.dup
    yield(configuration)
  ensure
    @configuration = previous_configuration
  end

  module_function :mml_adapter, :default_mml_adapter=, :load_mml,
                  :configuration, :configure, :with_configuration
end

default_adapter =
  if RUBY_ENGINE == "opal"
    require "plurimath/setup/oga"
    require "plurimath/setup/opal"
    :oga
  elsif ENV["PLURIMATH_LEPTRIS"]
    require "plurimath/setup/leptris_engine"
    :leptris
  elsif ENV["PLURIMATH_OGA"]
    require "plurimath/setup/oga"
    :oga
  else
    require "plurimath/setup/ox_engine"
    :ox
  end

if RUBY_ENGINE == "opal"
  Plurimath.mml_adapter(default_adapter)
else
  Plurimath.default_mml_adapter = default_adapter
end
