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
          slashes = "\\\\ "
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

        def to_omml_without_math_tag(display_style)
          br_tag = Utility.ox_element("br", namespace: "w")
          r_tag = (Utility.ox_element("r", namespace: "m") << br_tag)
          return r_tag unless parameter_one

          value_arr = parameter_one.insert_t_tag(display_style)
          value_arr.insert(attributes[:linebreakstyle] == "after" ? 1 : 0, r_tag )
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
