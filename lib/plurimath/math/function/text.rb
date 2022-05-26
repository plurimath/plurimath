# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Text < UnaryFunction
        def to_asciimath
          "\"#{parameter_one}\""
        end

        def to_mathml_without_math_tag
          regex_exp = %r{unicode\[:(?<unicode>\w{1,})\]}
          parameter_one.gsub!(regex_exp) do |_text|
            symbol_value(Regexp.last_match[:unicode]).to_s
          end
          "<mtext>#{parameter_one}</mtext>"
        end

        def symbol_value(unicode)
          Mathml::Constants::UNICODE_SYMBOLS.invert[unicode] ||
            Mathml::Constants::SYMBOLS.invert[unicode]
        end
      end
    end
  end
end
