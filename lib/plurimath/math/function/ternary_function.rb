# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class TernaryFunction < Core
        autoload :DisplayTreeMethods, "plurimath/math/function/ternary_function/display_tree_methods"

        extend Documentation

        CATALOG_TYPE = :ternary

        node_fields :parameter_one, :parameter_two, :parameter_three,
                    scalars: { hide_function_name: :boolean }

        def initialize(parameter_one = nil,
                       parameter_two = nil,
                       parameter_three = nil)
          @parameter_one = parameter_one
          @parameter_two = parameter_two
          @parameter_three = parameter_three
          ModelHelper.validate_left_right(variables.map { |var| get(var) })
        end

        def ==(object)
          self.class == object.class &&
            object.parameter_one == parameter_one &&
            object.parameter_two == parameter_two &&
            object.parameter_three == parameter_three
        end

        def to_asciimath(options:)
          if parameter_one
            first_value = first_field_wrap(parameter_one,
                                           options: options)
          end
          if parameter_two
            second_value = "_#{wrapped(parameter_two,
                                       options: options)}"
          end
          if parameter_three
            third_value = "^#{wrapped(parameter_three,
                                      options: options)}"
          end
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_mathml_without_math_tag(intent, options:)
          value_arr = [
            validate_mathml_fields(parameter_one, intent, options: options),
            validate_mathml_fields(parameter_two, intent, options: options),
            validate_mathml_fields(parameter_three, intent, options: options),
          ]
          class_tag = ox_element("m#{class_name}")
          XmlHelper.update_nodes(class_tag, value_arr)
        end

        def to_latex(options:)
          first_value  = parameter_one&.to_latex(options: options)
          second_value = parameter_two&.to_latex(options: options)
          third_value  = parameter_three&.to_latex(options: options)
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_html(options:)
          first_value  = "<i>#{parameter_one.to_html(options: options)}</i>" if parameter_one
          second_value = "<i>#{parameter_two.to_html(options: options)}</i>" if parameter_two
          third_value = "<i>#{parameter_three.to_html(options: options)}</i>" if parameter_three
          "#{first_value}#{second_value}#{third_value}"
        end

        def any_value_exist?
          parameter_one || parameter_two || parameter_three
        end

        def all_values_exist?
          !parameter_one.nil? &&
            !parameter_two.nil? &&
            !parameter_three.nil?
        end

        def to_asciimath_math_zone(spacing, last = false, _, options:)
          TernaryFunction.include(DisplayTreeMethods) unless TernaryFunction < DisplayTreeMethods
          super
        end

        def to_latex_math_zone(spacing, last = false, _, options:)
          TernaryFunction.include(DisplayTreeMethods) unless TernaryFunction < DisplayTreeMethods
          super
        end

        def to_mathml_math_zone(spacing, last = false, _, options:)
          TernaryFunction.include(DisplayTreeMethods) unless TernaryFunction < DisplayTreeMethods
          super
        end

        def to_omml_math_zone(spacing, last = false, _, display_style:,
options:)
          TernaryFunction.include(DisplayTreeMethods) unless TernaryFunction < DisplayTreeMethods
          super
        end

        def to_unicodemath_math_zone(spacing, last = false, _, options:)
          TernaryFunction.include(DisplayTreeMethods) unless TernaryFunction < DisplayTreeMethods
          super
        end

        protected

        def latex_wrapped(field, options:)
          field_value = field.to_latex(options: options)
          if field.validate_function_formula
            "{ \\left ( #{field_value} \\right ) }"
          else
            "{#{field_value}}"
          end
        end

        def wrapped(field, options:, type: "ascii")
          return "" unless field

          type == "ascii" ? "(#{field.to_asciimath(options: options)})" : "{#{field.to_latex(options: options)}}"
        end

        def first_field_wrap(field, options:, type: "ascii")
          return "" unless field

          if type == "ascii"
            ascii_wrap(field,
                       options: options)
          else
            latex_wrap(field,
                       options: options)
          end
        end

        def ascii_wrap(field, options:)
          asciimath = field.to_asciimath(options: options)
          return asciimath if ["obrace", "ubrace"].include?(field.class_name)

          case field
          when Formula || field.class.name.include?("Function")
            "(#{asciimath})"
          else
            asciimath
          end
        end

        def latex_wrap(field, options:)
          latex = field.to_latex(options: options)
          return latex if ["obrace", "ubrace"].include?(field.class_name)

          case field
          when Formula || field.class.name.include?("Function")
            "{#{latex}}"
          else
            latex
          end
        end

        def narypr(function_symbol, function_type: "undOvr")
          chr_arg     = { "m:val": function_symbol }
          limloc_arg  = { "m:val": function_type }
          subhide_arg = { "m:val": parameter_one ? "0" : "1" }
          suphide_arg = { "m:val": parameter_two ? "0" : "1" }
          chr_tag     = XmlHelper.ox_element("chr", attributes: chr_arg,
                                                    namespace: "m")
          limloc_tag  = XmlHelper.ox_element("limLoc", attributes: limloc_arg,
                                                       namespace: "m")
          subhide_tag = XmlHelper.ox_element("subHide", attributes: subhide_arg,
                                                        namespace: "m")
          suphide_tag = XmlHelper.ox_element("supHide", attributes: suphide_arg,
                                                        namespace: "m")
          nary_pr_tag = XmlHelper.ox_element("naryPr", namespace: "m")
          XmlHelper.update_nodes(
            nary_pr_tag,
            [
              chr_tag,
              limloc_tag,
              subhide_tag,
              suphide_tag,
            ],
          )
        end

        def validate_mathml_tag(parameter, intent, options:)
          return Array(XmlHelper.ox_element("mrow")) unless parameter

          Array(parameter.to_mathml_without_math_tag(intent, options: options))
        end

        def underover(display_style, options:)
          # Overset and Underset take script before base; OMML stores base in m:e.
          overset = Overset.new(parameter_three, parameter_one)
          unless parameter_two
            return overset.to_omml_without_math_tag(display_style,
                                                    options: options)
          end

          Underset.new(parameter_two, overset)&.to_omml_without_math_tag(
            display_style, options: options
          )
        end

        def naryand_value(field, options:)
          return "" unless field

          field_value = field.to_unicodemath(options: options)
          field.is_a?(Math::Function::Fenced) ? "▒#{field_value}" : "▒〖#{field_value}〗"
        end
      end
    end
  end
end
