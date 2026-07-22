# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Hat < UnaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "A hat (circumflex) accent over an expression."
        REFERENCE = "https://developer.mozilla.org/en-US/docs/Web/MathML/Reference/Element/mover"
        EXAMPLE = -> { new(sym("x")) }
        # --- end catalog documentation ---

        attr_accessor :attributes

        def initialize(parameter_one = nil, attributes = {})
          super(parameter_one)
          @attributes = attributes
        end

        def to_asciimath(options:)
          first_value = "(#{parameter_one.to_asciimath(options: options)})" if parameter_one
          "hat#{first_value}"
        end

        def to_latex(options:)
          first_value = "{#{parameter_one.to_latex(options: options)}}" if parameter_one
          "\\hat#{first_value}"
        end

        def to_mathml_without_math_tag(intent, options:)
          mo_tag = (XmlHelper.ox_element("mo") << "^")
          return mo_tag unless parameter_one

          mover_tag = XmlHelper.ox_element("mover")
          mover_tag.set_attr(attributes) if attributes && !attributes.empty?
          XmlHelper.update_nodes(
            mover_tag,
            [
              parameter_one&.to_mathml_without_math_tag(intent,
                                                        options: options),
              mo_tag,
            ],
          )
        end

        def validate_function_formula
          false
        end

        def to_omml_without_math_tag(display_style, options:)
          return r_element("^", rpr_tag: false) unless parameter_one
          if hide_function_name
            return omml_value(display_style,
                              options: options)
          end

          if attributes && attributes[:accent]
            accent_tag(display_style, options: options)
          else
            symbol = Symbols::Symbol.new("&#x302;") unless hide_function_name
            Overset.new(parameter_one, symbol).to_omml_without_math_tag(
              display_style, options: options
            )
          end
        end

        def to_unicodemath(options:)
          "#{unicodemath_parens(parameter_one, options: options)}̂"
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            obj.update(
              Overset.new(Utility.filter_values(obj.value), nil),
            )
          end
        end

        protected

        def accent_tag(display_style, options:)
          symbol  = "̂" unless hide_function_name
          acc_tag = XmlHelper.ox_element("acc", namespace: "m")
          acc_pr_tag = XmlHelper.ox_element("accPr", namespace: "m")
          acc_pr_tag << XmlHelper.ox_element("chr", namespace: "m",
                                                    attributes: { "m:val": symbol })
          XmlHelper.update_nodes(
            acc_tag,
            [
              acc_pr_tag,
              omml_parameter(parameter_one, display_style, tag_name: "e",
                                                           namespace: "m", options: options),
            ],
          )
          [acc_tag]
        end
      end
    end
  end
end
