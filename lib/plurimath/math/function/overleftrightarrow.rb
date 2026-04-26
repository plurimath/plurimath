# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Overleftrightarrow < UnaryFunction
        attr_accessor :attributes

        def initialize(parameter_one = nil, attributes = {})
          super(parameter_one)
          @attributes = attributes
        end

        def to_mathml_without_math_tag(intent, options:)
          mover = ox_element("mover")
          first_value = parameter_one&.to_mathml_without_math_tag(intent,
                                                                    options: options)
          if attributes && attributes[:accent]
            mover[:accent] =
              attributes[:accent]
          end
          Utility.update_nodes(
            mover,
            [
              first_value,
              Utility.ox_element("mo") << "&#x20e1;",
            ],
          )
        end

        def to_omml_without_math_tag(display_style, options:)
          return r_element("&#x20e1;", rpr_tag: false) unless parameter_one

          if attributes && attributes[:accent]
            acc_tag(display_style, options: options)
          else
            symbol = Symbols::Symbol.new("\u20e1")
            Overset.new(parameter_one, symbol).to_omml_without_math_tag(true,
                                                                          options: options)
          end
        end

        def to_unicodemath(options:)
          "#{unicodemath_parens(parameter_one, options: options)}\u20e1"
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          obj.update(Utility.filter_values(obj.value)) if obj.value_exist?
        end

        def accent_char
          "\u20e1"
        end

        protected

        def acc_tag(display_style, options:)
          acc_tag    = Utility.ox_element("acc", namespace: "m")
          acc_pr_tag = Utility.ox_element("accPr", namespace: "m")
          acc_pr_tag << Utility.ox_element("chr", namespace: "m",
                                                  attributes: { "m:val": "\u20e1" })
          Utility.update_nodes(
            acc_tag,
            [
              acc_pr_tag,
              omml_parameter(parameter_one, display_style, tag_name: "e",
                                                           options: options),
            ],
          )
          [acc_tag]
        end
      end
    end
  end
end
