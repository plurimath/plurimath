# frozen_string_literal: true

require_relative "binary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Mlabeledtr < BinaryFunction
        include Mathml::Utility

        def to_mathml_without_math_tag(intent, options:)
          table = ox_element("mtable")
          mlabeledtr = ox_element(class_name)
          labeledtr_td(mlabeledtr, parameter_two.to_mathml_without_math_tag(intent, options: options))
          labeledtr_td(mlabeledtr, parameter_one.to_mathml_without_math_tag(intent, options: options))
          table << mlabeledtr
        end

        def to_unicodemath(options:)
          "#{parameter_one&.to_unicodemath(options: options)}##{parameter_two&.value}"
        end

        def id=(value)
          return if value.nil?

          @parameter_two = Text.new(value)
        end

        def mtd_value=(value)
          return if value.nil? || value.empty?

          self.parameter_one = replace_order_with_value(
            clear_temp_order,
            update_temp_mathml_values(value),
            "mtd"
          )
        end

        protected

        def labeledtr_td(tr, value)
          tr << (ox_element("mtd") << value)
        end
      end
    end
  end
end
