# frozen_string_literal: true

module Plurimath
  module Errors
    autoload :Evaluation, "#{__dir__}/errors/evaluation"
    autoload :InvalidNumber, "#{__dir__}/errors/invalid_number"
    autoload :UnsupportedBase, "#{__dir__}/errors/unsupported_base"
    autoload :UnsupportedLocale, "#{__dir__}/errors/unsupported_locale"
  end
end
