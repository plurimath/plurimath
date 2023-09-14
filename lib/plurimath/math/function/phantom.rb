# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Phantom < UnaryFunction
        def to_asciimath
          "#{Array.new(parameter_one&.length, '\ ').join}"
        end

        def to_html
          "<i>#{Array.new(parameter_one&.length, '&nbsp;').join}</i>"
        end

        def to_latex
          Array.new(parameter_one&.length, '\\ ').join
        end

        def to_mathml_without_math_tag
          phantom = Utility.ox_element("mphantom")
          Utility.update_nodes(
            phantom,
            parameter_one&.map(&:to_mathml_without_math_tag),
          )
        end

        def to_omml_without_math_tag(display_style)
          string = Array.new(Array(parameter_one)&.length, "&#xa0;").join
          Array(
            Symbol.new(string).insert_t_tag(display_style),
          )
        end

        def updated_object_values(*); end
      end
    end
  end
end
