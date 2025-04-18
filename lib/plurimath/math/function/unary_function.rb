# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class UnaryFunction < Core
        attr_accessor :parameter_one, :hide_function_name

        def initialize(parameter_one = nil)
          parameter_one  = parameter_one.to_s if parameter_one.is_a?(Parslet::Slice)
          @parameter_one = parameter_one
          method(:post_initialize).call if methods.include?(:post_initialize)
          Utility.validate_left_right(variables.map { |var| get(var) })
        end

        def ==(object)
          object.class == self.class &&
            object.parameter_one == parameter_one
        end

        def to_asciimath(options:)
          value = if Utility::UNARY_CLASSES.any?(class_name)
                    asciimath_value(options: options)
                  elsif parameter_one
                    "(#{asciimath_value(options: options)})"
                  end
          "#{class_name}#{value}"
        end

        def to_mathml_without_math_tag(intent, options:)
          tag_name = if Utility::UNARY_CLASSES.include?(class_name)
                       insert_space_tags = true
                       "mi"
                     else
                       "mo"
                     end
          new_arr = []
          new_arr << (ox_element(tag_name) << class_name) unless hide_function_name
          unary_element = if parameter_one
                            new_arr += mathml_value(intent, options: options)
                            mrow = ox_element("mrow")
                            Utility.update_nodes(mrow, new_arr)
                            intentify(mrow, intent, func_name: :function, intent_name: intent_names[:name])
                          else
                            new_arr.first
                          end
          if insert_space_tags && options[:unary_function_spacing]
            Utility.update_nodes(
              ox_element("mrow"),
              [
                ox_element("mo", attributes: { rspace: "thickmathspace" }),
                unary_element,
              ],
            )
          else
            unary_element
          end
        end

        def to_latex(options:)
          "\\#{class_name}{#{latex_value(options: options)}}"
        end

        def to_html(options:)
          first_value = if parameter_one.is_a?(Array)
                          "<i>#{parameter_one.map { |val| val.to_html(options: options) }.join}</i>"
                        elsif parameter_one
                          "<i>#{parameter_one.to_html(options: options)}</i>"
                        end
          "<i>#{invert_unicode_symbols}</i>#{first_value}"
        end

        def to_omml_without_math_tag(display_style, options: {})
          return r_element(class_name, rpr_tag: false) unless parameter_one

          if @hide_function_name
            value = omml_value(display_style, options: options)
          else
            func = Utility.ox_element("func", namespace: "m")
            value = Utility.update_nodes(func, function_values(display_style, options: options))
          end
          Array(value)
        end

        def to_unicodemath(options:)
          "#{class_name}⁡#{parameter_one&.to_unicodemath(options: options)}"
        end

        def to_asciimath_math_zone(spacing, last = false, _, options:)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{to_asciimath(options: options)}\" function apply\n",
            "#{new_spacing}|_ \"#{class_name}\" function name\n",
          ]
          ascii_fields_to_print(parameter_one, { spacing: new_spacing, field_name: "argument", additional_space: "   |_ " , array: new_arr, options: options })
          new_arr
        end

        def to_latex_math_zone(spacing, last = false, _, options:)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{to_latex(options: options)}\" function apply\n",
            "#{new_spacing}|_ \"#{class_name}\" function name\n",
          ]
          latex_fields_to_print(parameter_one, { spacing: new_spacing, field_name: "argument", additional_space: "   |_ " , array: new_arr, options: options })
          new_arr
        end

        def to_mathml_math_zone(spacing, last = false, _, options:)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{dump_mathml(self, options: options)}\" function apply\n",
            "#{new_spacing}|_ \"#{class_name}\" function name\n",
          ]
          mathml_fields_to_print(parameter_one, { spacing: new_spacing, field_name: "argument", additional_space: "   |_ ", array: new_arr, options: options })
          new_arr
        end

        def to_omml_math_zone(spacing, last = false, _, display_style:, options:)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{dump_omml(self, display_style, options: options)}\" function apply\n",
            "#{new_spacing}|_ \"#{class_name}\" function name\n",
          ]
          omml_fields_to_print(parameter_one, { spacing: new_spacing, field_name: "argument", additional_space: "   |_ ", array: new_arr, display_style: display_style, options: options })
          new_arr
        end

        def to_unicodemath_math_zone(spacing, last = false, _, options:)
          new_spacing = gsub_spacing(spacing, last)
          new_arr = [
            "#{spacing}\"#{to_unicodemath(options: options)}\" function apply\n",
            "#{new_spacing}|_ \"#{class_name}\" function name\n",
          ]
          unicodemath_fields_to_print(parameter_one, { spacing: new_spacing, field_name: "argument", additional_space: "   |_ " , array: new_arr, options: options })
          new_arr
        end

        def custom_array_line_breaking(obj)
          parameter_value = result(parameter_one)
          if parameter_value.size > 1
            breaked_result = parameter_value.first.last.omml_line_break(parameter_value)
            update(Array(breaked_result.shift))
            obj.update(self.class.new(breaked_result.flatten))
            reprocess_parameter_one(obj)
            return
          end

          parameter_one.each.with_index(1) do |object, index|
            object.line_breaking(obj)
            break obj.insert(parameter_one.slice!(index..parameter_one.size)) if obj.value_exist?
          end
        end

        def update(value)
          self.parameter_one = value
        end

        def reprocess_parameter_one(obj)
          new_obj = Formula.new([])
          self.line_breaking(new_obj)
          if new_obj.value_exist?
            obj.value.insert(0, Linebreak.new)
            obj.value.insert(0, self.class.new(new_obj.value))
          end
        end

        def value_nil?
          !parameter_one
        end

        def intent_names
          { name: ":function" }
        end

        protected

        def asciimath_value(options:)
          return "" unless parameter_one

          case parameter_one
          when Array
            parameter_one.compact.map { |object| object&.to_asciimath(options: options) }.join
          else
            parameter_one.to_asciimath(options: options)
          end
        end

        def mathml_value(intent, options:)
          case parameter_one
          when Array
            parameter_one.compact.map { |object| object&.to_mathml_without_math_tag(intent, options: options) }
          else
            Array(parameter_one&.to_mathml_without_math_tag(intent, options: options))
          end
        end

        def latex_value(options:)
          if parameter_one.is_a?(Array)
            return parameter_one&.compact&.map { |object| object&.to_latex(options: options) }&.join(" ")
          end

          parameter_one&.to_latex(options: options)
        end

        def omml_value(display_style, options:)
          if parameter_one.is_a?(Array)
            return parameter_one&.compact&.map { |object| formula_to_nodes(object, display_style, options: options) }
          end

          Array(formula_to_nodes(parameter_one, display_style, options: options))
        end

        def formula_to_nodes(object, display_style, options:)
          object&.insert_t_tag(display_style, options: options)
        end

        def latex_paren
          Latex::Constants::LEFT_RIGHT_PARENTHESIS.invert[parameter_one] || '.'
        end

        def exist?
          !(parameter_one.is_a?(Array) ? parameter_one.empty? : parameter_one.nil?)
        end

        def function_values(display_style, options:)
          funcpr = Utility.ox_element("funcPr", namespace: "m")
          funcpr << Utility.pr_element("ctrl", true, namespace: "m")
          fname  = Utility.ox_element("fName", namespace: "m")
          fname << Utility.update_nodes(
            Utility.ox_element("r", namespace: "m"),
            [
              Utility.rpr_element,
              (Utility.ox_element("t", namespace: "m") << class_name),
            ],
          )
          me = Utility.ox_element("e", namespace: "m")
          Utility.update_nodes(me, omml_value(display_style, options: options)) if parameter_one
          [funcpr, fname, me]
        end
      end
    end
  end
end
