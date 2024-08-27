# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Linebreak < UnaryFunction
        attr_accessor :attributes

        def initialize(parameter_one = nil, attributes = {})
          @parameter_one = parameter_one
          @attributes = attributes
          Utility.validate_left_right([parameter_one])
        end

        def ==(object)
          object.class == self.class &&
            object.parameter_one == parameter_one &&
            object.linebreak == linebreak
        end

        def to_asciimath
          linebreak_character = "\\\n "
          return linebreak_character unless parameter_one

          case attributes[:linebreakstyle]
          when "after"
            "#{asciimath_value}#{linebreak_character}"
          else
            "#{linebreak_character}#{asciimath_value}"
          end
        end

        def to_latex
          linebreak_character = "\\\\ "
          return linebreak_character unless parameter_one

          case attributes[:linebreakstyle]
          when "after"
            "#{latex_value}#{linebreak_character}"
          else
            "#{linebreak_character}#{latex_value}"
          end
        end

        def to_mathml_without_math_tag(intent, options:)
          return Utility.ox_element("mo", attributes: { linebreak: "newline" }) unless parameter_one

          mo_node = parameter_one.to_mathml_without_math_tag(intent, options: options)
          mo_node.name = "mo" unless mo_node.name == "mo"
          mo_node.set_attr(attributes) unless attributes.empty?
          mo_node
        end

        def to_html
          br_tag = "<br/>"
          return br_tag unless parameter_one

          case attributes[:linebreakstyle]
          when "after"
            "#{parameter_one.to_html}#{br_tag}"
          else
            "#{br_tag}#{parameter_one.to_html}"
          end
        end

        def to_omml_without_math_tag(display_style)
          parameter_one&.insert_t_tag(display_style)
        end

        def omml_line_break(result)
          result.first.pop
          return result unless exist?

          case attributes[:linebreakstyle]
          when "after"
            result[0] << parameter_one
          else
            result[1].insert(0, parameter_one)
          end
          result
        end

        def to_unicodemath
          first_value = parameter_one.to_unicodemath if parameter_one
          "&#xa;#{first_value}"
        end

        def separate_table
          true
        end

        def linebreak
          true
        end
      end
    end
  end
end
