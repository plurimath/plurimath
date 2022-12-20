# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Phantom < UnaryFunction
        def to_asciimath
          "\"#{Array.new(parameter_one&.length, ' ').join}\""
        end

        def to_html
          "<i>#{Array.new(parameter_one&.length, '&nbsp;').join}</i>"
        end

        def to_latex
          "<i>#{Array.new(parameter_one&.length, '\\ ').join}</i>"
        end

        def to_mathml_without_math_tag
          mi_tag_value = Array.new(parameter_one&.length, "&nbsp;&nbsp;").join
          Utility.ox_element("mi") << mi_tag_value
        end
      end
    end
  end
end
