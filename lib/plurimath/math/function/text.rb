# frozen_string_literal: true

require "htmlentities"
require_relative "unary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Text < UnaryFunction
        include Mathml::Utility

        PARSER_REGEX = %r{unicode\[:(?<unicode>\w{1,})\]}.freeze

        def initialize(parameter_one = "", lang: nil)
          super(parameter_one)
          @lang = lang
        end

        def ==(object)
          object.class == self.class &&
            object.parameter_one == self.parameter_one
        end

        def to_asciimath(**)
          "\"#{parse_text('asciimath') || parameter_one}\""
        end

        def to_mathml_without_math_tag(intent, **)
          text = ox_element("mtext")
          return text unless parameter_one

          text << (parse_text("mathml") || parameter_one)
        end

        def to_latex(**)
          text_value = parse_text("latex") || parameter_one
          "\\text{#{text_value}}"
        end

        def to_html(**)
          parse_text("html") || parameter_one
        end

        def to_omml_without_math_tag(_, **)
          text = Utility.ox_element("t", namespace: "m")
          text << (parse_text("omml") || parameter_one)
          [text]
        end

        def to_unicodemath(**)
          return unless value

          value&.start_with?("\\") ? value : "\"#{(Utility.html_entity_to_unicode(value))}\""
        end

        def insert_t_tag(display_style, options:)
          r_tag = Utility.ox_element("r", namespace: "m")
          if @lang&.to_s != "omml"
            rpr_tag = Utility.ox_element("rPr", namespace: "m")
            rpr_tag << msty_tag_with_attrs
            r_tag << rpr_tag
          end
          Utility.update_nodes(
            r_tag,
            [omml_nodes(display_style, options: options)],
          )
          [r_tag]
        end

        def validate_function_formula
          false
        end

        def to_asciimath_math_zone(spacing, _, _, options:)
          "#{spacing}#{to_asciimath(options: options)} text\n"
        end

        def to_latex_math_zone(spacing, _, _, options:)
          "#{spacing}#{to_asciimath(options: options)} text\n"
        end

        def to_mathml_math_zone(spacing, _, _, options:)
          "#{spacing}\"#{dump_mathml(self, options: options)}\" text\n"
        end

        def to_omml_math_zone(spacing, _, _, display_style:, options:)
          "#{spacing}\"#{dump_omml(self, display_style, options: options)}\" text\n"
        end

        def to_unicodemath_math_zone(spacing, _, _, options:)
          "#{spacing}#{to_unicodemath(options: options)} text\n"
        end

        def value
          parameter_one
        end

        def element_order=(*); end

        def value=(text)
          text = text.join if text.is_a?(Array)
          entities = HTMLEntities.new
          symbols  = Mathml::Constants::UNICODE_SYMBOLS.transform_keys(&:to_s)
          text     = entities.encode(text, :hexadecimal)
          symbols.each do |code, string|
            text = text.gsub(code.downcase, "unicode[:#{string}]")
          end
          self.parameter_one = text
        end

        protected

        def symbol_value(unicode)
          Mathml::Constants::UNICODE_SYMBOLS.invert[unicode] ||
            Mathml::Constants::SYMBOLS.invert[unicode]
        end

        def parse_text(lang)
          html_value = first_value(lang).dup
          html_value = html_value&.gsub(PARSER_REGEX) do |_text|
            last_match = Regexp.last_match
            case lang
            when "mathml", "html", "omml"
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
              entities.decode(parameter_one&.gsub(/ /, "&#xa0;")),
              :hexadecimal,
            )
          else
            parameter_one
          end
        end
      end
    end
  end
end
