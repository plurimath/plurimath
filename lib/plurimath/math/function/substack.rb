# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Substack < UnaryFunction
        FUNCTION = {
          name: "substack",
          first_value: "above",
          second_value: "below",
        }.freeze

        def to_asciimath(options:)
          "{:#{parameter_one&.compact&.map { |param| param.to_asciimath(options: options) }&.join(",")}:}"
        end

        def to_latex(options:)
          "\\#{class_name}{#{parameter_one&.compact&.map { |param| param.to_latex(options: options) }&.join(" \\\\ ")}}"
        end

        def to_mathml_without_math_tag(intent, options:)
          Utility.update_nodes(
            ox_element("mtable"),
            mathml_value(intent, options: options),
          )
        end

        def to_omml_without_math_tag(display_style, options:)
          Table.new(parameter_one).to_omml_without_math_tag(display_style, options: options)
        end

        def to_unicodemath(options:)
          "■(#{parameter_one&.compact&.map { |param| param.to_unicodemath(options: options) }&.join("@")})"
        end
      end
    end
  end
end
