# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class TernaryFunction
        attr_accessor :parameter_one, :parameter_two, :parameter_three

        def initialize(parameter_one = nil,
                       parameter_two = nil,
                       parameter_three = nil)
          @parameter_one = parameter_one
          @parameter_two = parameter_two
          @parameter_three = parameter_three
          Utility.validate_left_right([parameter_one, parameter_two, parameter_three])
        end

        def to_asciimath
          first_value = first_field_wrap(parameter_one) if parameter_one
          second_value = "_#{wrapped(parameter_two)}" if parameter_two
          third_value = "^#{wrapped(parameter_three)}" if parameter_three
          "#{first_value}#{second_value}#{third_value}"
        end

        def ==(object)
          self.class == object.class &&
            object.parameter_one == parameter_one &&
            object.parameter_two == parameter_two &&
            object.parameter_three == parameter_three
        end

        def to_mathml_without_math_tag
          value_arr = [parameter_one&.to_mathml_without_math_tag]
          value_arr << parameter_two&.to_mathml_without_math_tag
          value_arr << parameter_three&.to_mathml_without_math_tag
          class_tag = Utility.ox_element("m#{class_name}")
          Utility.update_nodes(class_tag, value_arr)
        end

        def to_latex
          first_value  = parameter_one&.to_latex
          second_value = parameter_two&.to_latex
          third_value  = parameter_three&.to_latex
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_html
          first_value  = "<i>#{parameter_one.to_html}</i>" if parameter_one
          second_value = "<i>#{parameter_two.to_html}</i>" if parameter_two
          third_value = "<i>#{parameter_three.to_html}</i>" if parameter_three
          "#{first_value}#{second_value}#{third_value}"
        end

        def to_omml_without_math_tag
          r_tag = Utility.ox_element("r", namespace: "m")
          value_array = []
          value_array << omml_value(parameter_one) if parameter_one
          value_array << omml_value(parameter_two) if parameter_two
          value_array << omml_value(parameter_three) if parameter_three
          Utility.update_nodes(r_tag, value_array)
          [r_tag]
        end

        def class_name
          self.class.name.split("::").last.downcase
        end

        protected

        def latex_wrapped(field)
          if validate_function_formula(field)
            "{ \\left ( #{field.to_latex} \\right ) }"
          else
            "{#{field.to_latex}}"
          end
        end

        def validate_function_formula(field)
          unary_classes = (Utility::UNARY_CLASSES + ["obrace", "ubrace", "hat"])
          if field.is_a?(Formula)
            !(field.value.any?(Left) || field.value.any?(Right))
          elsif unary_classes.include?(field.class_name)
            false
          elsif field.class.name.include?("Function") || field.is_a?(FontStyle)
            !field.is_a?(Text)
          end
        end

        def invert_unicode_symbols
          Mathml::Constants::UNICODE_SYMBOLS.invert[class_name] || class_name
        end

        def omml_value(field)
          case field
          when Array
            field.compact.map(&:to_omml_without_math_tag)
          else
            insert_t_tag(field)
          end
        end

        def wrapped(field, type: "ascii")
          return "" unless field

          type == "ascii" ? "(#{field.to_asciimath})" : "{#{field.to_latex}}"
        end

        def first_field_wrap(field, type: "ascii")
          return "" unless field

          type == "ascii" ? ascii_wrap(field) : latex_wrap(field)
        end

        def ascii_wrap(field)
          asciimath = field.to_asciimath
          return latex if ["obrace", "ubrace"].include?(field.class_name)

          case field
          when Formula || field.class.name.include?("Function")
            "(#{asciimath})"
          else
            asciimath
          end
        end

        def latex_wrap(field)
          latex = field.to_latex
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
          limLoc_arg  = { "m:val": function_type }
          subhide_arg = { "m:val": "0" }
          suphide_arg = { "m:val": "0" }
          chr_tag     = Utility.ox_element("chr", attributes: chr_arg ,namespace: "m")
          limLoc_tag  = Utility.ox_element("limLoc", attributes: limLoc_arg ,namespace: "m")
          subHide_tag = Utility.ox_element("subHide", attributes: subhide_arg ,namespace: "m")
          supHide_tag = Utility.ox_element("supHide", attributes: suphide_arg ,namespace: "m")
          nary_pr_tag = Utility.ox_element("naryPr" ,namespace: "m")
          Utility.update_nodes(
            nary_pr_tag,
            [
              chr_tag,
              limLoc_tag,
              subHide_tag,
              supHide_tag,
            ],
          )
        end

        def sub_parameter
          sub_tag = Utility.ox_element("sub", namespace: "m")
          return empty_tag(sub_tag) unless parameter_one

          Utility.update_nodes(sub_tag, insert_t_tag(parameter_one))
        end

        def sup_parameter
          sup_tag = Utility.ox_element("sup", namespace: "m")
          return empty_tag(sup_tag) unless parameter_two

          Utility.update_nodes(sup_tag, insert_t_tag(parameter_two))
        end

        def e_parameter
          e_tag = Utility.ox_element("e", namespace: "m")
          return empty_tag(e_tag) unless parameter_three

          Utility.update_nodes(e_tag, insert_t_tag(parameter_three))
        end

        def empty_tag(wrapper_tag)
          r_tag = Utility.ox_element("r", namespace: "m")
          r_tag << (Utility.ox_element("t", namespace: "m") << "&#8203;")
          wrapper_tag << r_tag
        end

        def insert_t_tag(parameter)
          parameter_value = parameter.to_omml_without_math_tag
          r_tag = Utility.ox_element("r", namespace: "m")
          if parameter.is_a?(Symbol)
            r_tag << (Utility.ox_element("t", namespace: "m") << parameter_value)
            [r_tag]
          elsif parameter.is_a?(Number)
            Utility.update_nodes(r_tag, parameter_value)
            [r_tag]
          else
            Array(parameter_value)
          end
        end

        def underover_class?(field)
          if field.is_a?(Symbol)
            ["&#x22c0;", "&#x22c1;", "&#x22c2;", "&#x22c3;"].include?(field.value)
          else
            ["ubrace", "obrace"].include?(field.class_name)
          end
        end

        def present?
          !(parameter_one.nil? && parameter_two.nil? && parameter_three.nil?)
        end
      end
    end
  end
end
