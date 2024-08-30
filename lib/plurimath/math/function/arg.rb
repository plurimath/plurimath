# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Arg < BinaryFunction
        def to_mathml_without_math_tag(intent, options:)
          first_value = parameter_one.to_mathml_without_math_tag(intent, options: options)
          first_value.attributes[:arg] = Utility.html_entity_to_unicode(parameter_two.value)
          first_value
        end

        def to_unicodemath(options:)
          first_value = "(#{parameter_two&.to_unicodemath(options: options)} #{parameter_one&.to_unicodemath(options: options)})" if parameter_one || parameter_two
          "ⓐ#{first_value}"
        end
      end
    end
  end
end
