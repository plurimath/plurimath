# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Mod < BinaryFunction
        def to_asciimath
          first_value = parameter_one.to_asciimath if parameter_one
          second_value = parameter_two.to_asciimath if parameter_two
          "#{first_value}mod#{second_value}"
        end

        def to_latex
          first_value = "{#{parameter_one.to_latex}}" if parameter_one
          second_value = "{#{parameter_two.to_latex}}" if parameter_two
          "#{first_value}\\pmod#{second_value}"
        end

        def to_html
          first_value = "<i>#{parameter_one.to_html}</i>" if parameter_one
          second_value = "<i>#{parameter_two.to_html}</i>" if parameter_two
          "#{first_value}<i>mod</i>#{second_value}"
        end
      end
    end
  end
end
