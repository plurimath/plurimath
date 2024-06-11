# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Nary < Core
        attr_accessor :parameter_one, :parameter_two, :parameter_three, :parameter_four, :options

        def initialize(parameter_one = nil,
                       parameter_two = nil,
                       parameter_three = nil,
                       parameter_four = nil,
                       options = {})
          @parameter_one = parameter_one
          @parameter_two = parameter_two
          @parameter_three = parameter_three
          @parameter_four = parameter_four
          @options = options
          Utility.validate_left_right([parameter_one, parameter_two, parameter_three, parameter_four])
        end

        def ==(object)
          self.class == object.class &&
            object.parameter_one == parameter_one &&
            object.parameter_two == parameter_two &&
            object.parameter_three == parameter_three &&
            object.parameter_four == parameter_four &&
            object.options == options
        end

        def to_asciimath
          first_value  = parameter_one&.to_asciimath || "int"
          second_value = "_(#{parameter_two.to_asciimath})" if parameter_two
          third_value  = "^(#{parameter_three.to_asciimath})" if parameter_three
          fourth_value = " #{parameter_four.to_asciimath}" if parameter_four
          "#{first_value}#{second_value}#{third_value}#{fourth_value}"
        end

        def to_latex
          first_value  = parameter_one&.to_latex || "\\int"
          second_value = "_{#{parameter_two.to_latex}}" if parameter_two
          third_value  = "^{#{parameter_three.to_latex}}" if parameter_three
          fourth_value = " #{parameter_four.to_latex}" if parameter_four
          "#{first_value}#{second_value}#{third_value}#{fourth_value}"
        end

        def to_mathml_without_math_tag(intent)
          new_arr = [
            validate_mathml_fields(parameter_one, intent),
            validate_mathml_fields(parameter_two, intent),
            validate_mathml_fields(parameter_three, intent),
          ]
          subsup_tag = Utility.update_nodes(ox_element(tag_name), new_arr)
          mask_subsup_tag(subsup_tag) if options.dig(:mask)
          return subsup_tag unless parameter_four

          intentify(
            Utility.update_nodes(
              ox_element("mrow"),
              [
                subsup_tag,
                wrap_mrow(validate_mathml_fields(parameter_four, intent), true),
              ],
            ),
            intent,
            func_name: :naryand,
            intent_name: intent_name,
          )
        end

        def to_omml_without_math_tag(display_style)
          nary_element = Utility.ox_element("nary", namespace: "m")
          Utility.update_nodes(nary_element, omml_nary_tag(display_style))
          Array(nary_element)
        end

        def to_unicodemath
          first_value = sub_value if parameter_two
          second_value = sup_value if parameter_three
          if prime_unicode?(parameter_three)
            "#{parameter_one&.to_unicodemath}#{second_value}#{first_value}#{naryand_value(parameter_four)}"
          else
            "#{parameter_one&.to_unicodemath}#{first_value}#{second_value}#{naryand_value(parameter_four)}"
          end
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            obj.update(
              self.class.new(
                Utility.filter_values(obj.value),
                self.parameter_two,
                self.parameter_three,
                self.parameter_four,
                self.options,
              )
            )
            self.parameter_two = nil
            self.parameter_three = nil
            self.parameter_four = nil
            return
          end

          parameter_two&.line_breaking(obj)
          if obj.value_exist?
            obj.update(
              self.class.new(
                nil,
                Utility.filter_values(obj.value),
                self.parameter_three,
                self.parameter_four,
                self.options
              )
            )
            self.parameter_three = nil
            self.parameter_four = nil
            return
          end

          parameter_four&.line_breaking(obj)
          if obj.value_exist?
            obj.update(Utility.filter_values(obj.value))
          end
        end

        protected

        def chr_value(narypr)
          first_value = Utility.html_entity_to_unicode(parameter_one&.nary_attr_value)
          narypr << Utility.ox_element("chr", namespace: "m", attributes: { "m:val": first_value }) unless first_value == "∫"

          narypr << Utility.ox_element("limLoc", namespace: "m", attributes: { "m:val": (options[:type] || "subSup").to_s })
          hide_tags(narypr, parameter_two, "sub")
          hide_tags(narypr, parameter_three, "sup")
          narypr
        end

        def hide_tags(nar, field, tag_prefix)
          return nar unless field.nil?

          nar << Utility.ox_element("#{tag_prefix}Hide", namespace: "m", attributes: { "m:val": "1" })
        end

        def omml_nary_tag(display_style)
          narypr = Utility.ox_element("naryPr", namespace: "m")
          chr_value(narypr)
          [
            (narypr << Utility.pr_element("ctrl", true, namespace: "m")),
            omml_parameter(parameter_two, display_style, tag_name: "sub"),
            omml_parameter(parameter_three, display_style, tag_name: "sup"),
            omml_parameter(parameter_four, display_style, tag_name: "e"),
          ]
        end

        def sup_value
          if parameter_three.mini_sized? || prime_unicode?(parameter_three)
            parameter_three.to_unicodemath
          elsif parameter_three.is_a?(Math::Function::Power)
            "^#{parameter_three.to_unicodemath}"
          elsif parameter_one.is_a?(Math::Function::Power) && parameter_one&.prime_unicode?(parameter_one&.parameter_two)
            "^#{parameter_three.to_unicodemath}"
          else
            "^#{unicodemath_parens(parameter_three)}"
          end
        end

        def sub_value
          if parameter_two.mini_sized?
            parameter_two.to_unicodemath
          elsif parameter_two.is_a?(Math::Function::Base)
            "_#{parameter_two.to_unicodemath}"
          else
            "_#{unicodemath_parens(parameter_two)}"
          end
        end

        def naryand_value(field)
          return "" unless field

          field_value = field.to_unicodemath
          field.is_a?(Math::Function::Fenced) ? "▒#{field_value}" : "▒〖#{field_value}〗"
        end

        def tag_name
          tag = options[:type] == "undOvr" ? "munderover" : "msubsup"
          if !(parameter_two && parameter_three)
            if parameter_two
              tag == "munderover" ? "munder" : "msub"
            elsif parameter_three
              tag == "munderover" ? "mover" : "msup"
            else
             'mrow'
            end
          else
            tag
          end
        end

        def masked_tag(tag)
          options_array = get_mask_options
          if options_array.include?("show_up_limit_place_holder") && parameter_three.nil?
            set_place_holder(tag, type: :above)
          end
          if options_array.include?("show_low_limit_place_holder") && parameter_two.nil?
            set_place_holder(tag, type: :below)
          end
          if options_array.include?("limits_opposite")
            change_power_base_values(tag)
          end
          if options_array.include?("limits_under_over")
            # TODO: change tag name to munderover
          end
          if options_array.include?("limits_sub_sup")
            # TODO: change tag name to msubsup
          end
          if options_array.include?("upper_limit_as_super_script")
            # TODO: change mover to msup
          end
        end

        def get_mask_options(mask_options = [])
          mask = options&.dig(:mask).to_i

          case mask % 4
          when 0 then mask_options << "limits_default"
          when 1 then mask_options << "limits_under_over"
          when 2 then mask_options << "limits_sub_sup"
          when 3 then mask_options << "upper_limit_as_super_script"
          end

          mask -= mask % 4

          case mask % 32
          when 4 then mask_options << "limits_opposite"
          when 8 then mask_options << "show_low_limit_place_holder"
          when 12 then mask_options += ["limits_opposite", "show_low_limit_place_holder"]
          when 16 then mask_options << "show_up_limit_place_holder"
          when 20 then mask_options += ["limits_opposite", "show_up_limit_place_holder"]
          when 24 then mask_options += ["show_low_limit_place_holder", "show_up_limit_place_holder"]
          when 28 then mask_options += ["limits_opposite", "show_low_limit_place_holder", "show_up_limit_place_holder"]
          end

          mask_options
        end

        def intent_name
          return "n-ary" unless parameter_one&.is_nary_symbol?

          parameter_one.nary_intent_name
        end

        def mask_subsup_tag(tag)
          masked_tag(tag)
          # IN progress yet!
        end

        def change_power_base_values(tag)
          case tag.name
          when "msub", "munder" then # TODO: Update the values nodes if needed
          when "msup", "mover" then # TODO: Update the values nodes if needed
          when "munderover", "msubsup" then # TODO: Update the values nodes if needed
          end
        end

        def set_place_holder(node, type:)
          nodes = if type == :below
                    node.name = node.name == "msup" ? "msubsup" : "munderover"
                    node.nodes.insert(1, mo_tag("&#x2b1a;"))
                  else
                    node.name = node.name == "msub" ? "msubsup" : "munderover"
                    node.nodes.insert(2, mo_tag("&#x2b1a;"))
                  end
          Plurimath.xml_engine.replace_nodes(node, nodes)
        end

        def mo_tag(str)
          ox_element("mo") << str
        end
      end
    end
  end
end
