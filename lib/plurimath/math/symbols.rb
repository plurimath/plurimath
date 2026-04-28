# frozen_string_literal: true

require_relative "symbols/symbol"
module Plurimath
  module Math
    module Symbols
    end
  end
end

(
  Dir.glob(File.join(__dir__, "symbols/", "*.rb")) +
  Dir.glob(File.join(__dir__, "symbols/", "*", "*.rb"))
).each { |file| require file } if RUBY_ENGINE != "opal"
