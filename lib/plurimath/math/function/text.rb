# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Text < UnaryFunction
        def to_asciimath
          "\"#{parse_text('asciimath') || parameter_one}\""
        end

        def to_mathml_without_math_tag
          "<mtext>#{parse_text('mathml') || parameter_one}</mtext>"
        end

        def symbol_value(unicode)
          Mathml::Constants::UNICODE_SYMBOLS.invert[unicode] ||
            Mathml::Constants::SYMBOLS.invert[unicode]
        end

        def to_latex
          parse_text("latex") || parameter_one
        end

        def to_html
          parse_text("html") || parameter_one
        end

        def parse_text(lang)
          regex = %r{\\mbox\{(?<mbox>.{1,})\}|unicode\[:(?<unicode>\w{1,})\]}
          parameter_one.gsub!(regex) do |_text|
            last_match = Regexp.last_match
            if ["mathml", "html"].include?(lang)
              symbol_value(last_match[:unicode]) || last_match[:mbox]
            else
              last_match[:unicode] || last_match[:mbox]
            end
          end
        end

        def to_html
          parameter_one
        end
      end
    end
  end
end
