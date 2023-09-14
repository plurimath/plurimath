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
          second_value = "_#{parameter_two.to_asciimath}" if parameter_two
          third_value  = "^#{parameter_three.to_asciimath}" if parameter_three
          fourth_value = " #{parameter_four.to_asciimath}" if parameter_four
          "#{first_value}#{second_value}#{third_value}#{fourth_value}"
        end

        def to_latex
          first_value  = parameter_one&.to_latex || "\\int"
          second_value = "_#{parameter_two.to_latex}" if parameter_two
          third_value  = "^#{parameter_three.to_latex}" if parameter_three
          fourth_value = "{#{parameter_four.to_latex}}" if parameter_four
          "#{first_value}#{second_value}#{third_value}#{fourth_value}"
        end

        def to_mathml_without_math_tag
          tag_name = options[:type] == "undOvr" ? "munderover" : "msubsup"
          subsup_tag = Utility.ox_element(tag_name)
          new_arr = []
          new_arr << validate_mathml_fields(parameter_one)
          new_arr << validate_mathml_fields(parameter_two)
          new_arr << validate_mathml_fields(parameter_three)
          Utility.update_nodes(subsup_tag, new_arr)
        end

        def to_omml_without_math_tag(display_style)
          nary_element = Utility.ox_element("nary", namespace: "m")
          Utility.update_nodes(nary_element, omml_nary_tag(display_style))
          Array(nary_element)
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            obj.update(self.class.new(Utility.filter_values(obj.value), parameter_two, parameter_three, parameter_four))
            self.parameter_two = nil
            self.parameter_three = nil
            self.parameter_four = nil
            return
          end

          parameter_two&.line_breaking(obj)
          if obj.value_exist?
            obj.update(self.class.new(nil, Utility.filter_values(obj.value), parameter_three, parameter_four))
            self.parameter_three = nil
            self.parameter_four = nil
            return
          end

          parameter_four&.line_breaking(obj)
          if obj.value_exist?
            obj.update(self.class.new(nil, nil, nil, Utility.filter_values(obj.value)))
          end
        end

        protected

        def chr_value(narypr)
          first_value = Utility.html_entity_to_unicode(parameter_one&.nary_attr_value)
          narypr << Utility.ox_element("chr", namespace: "m", attributes: { "m:val": first_value }) unless first_value == "∫"

          narypr << Utility.ox_element("limLoc", namespace: "m", attributes: { "m:val": options[:type].to_s })
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
      end
    end
  end
end
