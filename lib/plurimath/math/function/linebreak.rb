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
          slashes = "\\\n "
          return slashes unless parameter_one

          case attributes[:linebreakstyle]
          when "after"
            "#{asciimath_value}#{slashes}"
          else
            "#{slashes}#{asciimath_value}"
          end
        end

        def to_latex
          slashes = "\\\\ "
          return slashes unless parameter_one

          case attributes[:linebreakstyle]
          when "after"
            "#{latex_value}#{slashes}"
          else
            "#{slashes}#{latex_value}"
          end
        end

        def to_mathml_without_math_tag
          return Utility.ox_element("mo", attributes: { linebreak: "newline" }) unless parameter_one

          mo_node = parameter_one.to_mathml_without_math_tag
          mo_node.name = "mo" unless mo_node.name == "mo"
          mo_node.attributes.merge!(attributes) unless attributes.empty?
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

        def to_omml_without_math_tag(_)
          []
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
