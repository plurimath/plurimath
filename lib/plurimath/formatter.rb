# frozen_string_literal: true

module Plurimath
  module Formatter
    autoload :NumericFormatter, "#{__dir__}/formatter/numeric_formatter"
    autoload :NumberFormatter, "#{__dir__}/formatter/number_formatter"
    autoload :SupportedLocales, "#{__dir__}/formatter/supported_locales"
    autoload :UnsupportedBase, "#{__dir__}/errors/formatter/unsupported_base"
    autoload :Numbers, "#{__dir__}/formatter/numbers"
  end
end
