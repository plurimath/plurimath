require_relative "plurimath/version"
require "mml/configuration"

def mml_adapter(adapter)
  require "lutaml/model"
  Mml::Configuration.adapter = adapter unless Mml::Configuration.adapter
end

# Select an XML engine
if RUBY_ENGINE == 'opal'
  require "plurimath/setup/oga"
  require "plurimath/setup/opal"
  mml_adapter(:oga)
elsif ENV['PLURIMATH_OGA']
  require "plurimath/setup/oga"
  mml_adapter(:oga)
else
  require "plurimath/setup/ox_engine"
  mml_adapter(:ox)
end

require "plurimath/math"
