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
          masked_tag(subsup_tag) if options.dig(:mask)
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

        def intent_name
          return "n-ary" unless parameter_one&.is_nary_symbol?

          parameter_one.nary_intent_name
        end
      end
    end
  end
end
