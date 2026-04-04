# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      autoload :Base, "#{__dir__}/numbers/base"
      autoload :Fraction, "#{__dir__}/numbers/fraction"
      autoload :Integer, "#{__dir__}/numbers/integer"
      autoload :Significant, "#{__dir__}/numbers/significant"
    end
  end
end
