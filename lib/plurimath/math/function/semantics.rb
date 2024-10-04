# frozen_string_literal: true

require_relative "binary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Semantics < BinaryFunction
        include Mathml::Utility

        FUNCTION = {
          name: "semantics",
          first_value: "first argument",
          second_value: "second argument",
        }.freeze

        def to_mathml_without_math_tag(intent, options:)
          first_value = parameter_one&.to_mathml_without_math_tag(intent, options: options)
          Utility.update_nodes(
            Utility.ox_element("semantics"),
            other_tags(parameter_two, intent, options: options).insert(0, first_value),
          )
        end

        def to_latex(options:)
          parameter_one&.to_latex(options: options)
        end

        def to_asciimath(options:)
          parameter_one&.to_asciimath(options: options)
        end

        def to_omml_without_math_tag(display_style, options:)
          Array(parameter_one.insert_t_tag(display_style, options: options))
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            semantics = self.class.new(Utility.filter_values(obj.value), self.parameter_two)
            self.parameter_two = nil
            obj.update(semantics)
          end
        end

        def annotation=(value)
          return unless value

          @parameter_two = [
            {
              annotation: value,
            }
          ]
          @temp_mathml_order.delete("annotation")
        end

        protected

        def other_tags(array, intent, options:)
          contented = []
          array&.each do |hash|
            hash.each do |tag, content|
              tag_element = Utility.ox_element(tag&.to_s)
              contented << Utility.update_nodes(
                tag_element,
                content&.map { |object| object&.to_mathml_without_math_tag(intent, options: options) },
              )
            end
          end
          contented
        end
      end
    end
  end
end
