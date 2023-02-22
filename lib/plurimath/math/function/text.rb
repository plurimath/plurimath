# frozen_string_literal: true

require "htmlentities"
require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Text < UnaryFunction
        PARSER_REGEX = %r{unicode\[:(?<unicode>\w{1,})\]}.freeze

        def to_asciimath
          "\"#{parse_text('asciimath') || parameter_one}\""
        end

        def to_mathml_without_math_tag
          text = Utility.ox_element("mtext")
          text << (parse_text("mathml") || parameter_one) if parameter_one
        end

        def to_latex
          text_value = parse_text("latex") || parameter_one
          "\\text{#{text_value}}"
        end

        def to_html
          parse_text("html") || parameter_one
        end

        def to_omml_without_math_tag
          text = Utility.ox_element("t", namespace: "m")
          text << (parse_text("omml") || parameter_one)
        end

        protected

        def symbol_value(unicode)
          Mathml::Constants::UNICODE_SYMBOLS.invert[unicode] ||
            Mathml::Constants::SYMBOLS.invert[unicode]
        end

        def parse_text(lang)
          html_value = first_value(lang).dup
          html_value&.gsub!(PARSER_REGEX) do |_text|
            last_match = Regexp.last_match
            if ["mathml", "html"].include?(lang)
              symbol_value(last_match[:unicode])
            else
              last_match[:unicode]
            end
          end
          html_value
        end

        def first_value(lang)
          if lang == "omml"
            entities = HTMLEntities.new
            entities.encode(
              entities.decode(parameter_one),
              :named,
            )
          else
            parameter_one
          end
        end
      end
    end
  end
end
