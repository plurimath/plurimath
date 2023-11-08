
require_relative "plurimath/version"

# Select an XML engine
if RUBY_ENGINE == 'opal'
  require "plurimath/setup/oga"
  require "plurimath/setup/opal"
elsif ENV['PLURIMATH_OGA']
  require "plurimath/setup/oga"
else
  require "plurimath/setup/ox"
end

require "plurimath/math"
