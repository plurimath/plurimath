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
      end
    end
  end
end
