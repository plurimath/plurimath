# frozen_string_literal: true

require_relative "unary_function"

module Plurimath
  module Math
    module Function
      class Bar < UnaryFunction
        attr_accessor :attributes

        def initialize(parameter_one = nil, attributes = {})
          super(parameter_one)
          @attributes = attributes
        end

        def to_asciimath(options:)
          first_value = "(#{parameter_one.to_asciimath(options: options)})" if parameter_one
          "bar#{first_value}"
        end

        def to_latex(options:)
          first_value = "{#{parameter_one.to_latex(options: options)}}" if parameter_one
          "\\overline#{first_value}"
        end

        def to_mathml_without_math_tag(intent, options:)
          mo_tag = Utility.ox_element("mo") << "&#xaf;"
          return mo_tag unless parameter_one

          mover_tag = Utility.ox_element("mover")
          mover_tag.set_attr(attributes) if attributes && !attributes.empty?
          Utility.update_nodes(
            mover_tag,
            [
              parameter_one&.to_mathml_without_math_tag(intent, options: options),
              mo_tag,
            ],
          )
        end

        def to_omml_without_math_tag(display_style, options:)
          return r_element("&#xaf;", rpr_tag: false) unless parameter_one

          attributes && attributes[:accent] ? acc_tag(display_style, options: options) : bar_tag(display_style, options: options)
        end

        def swap_class
          Ul.new(parameter_one, attributes)
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          obj.update(Utility.filter_values(obj.value)) if obj.value_exist?
        end

        def to_unicodemath(options:)
          "#{unicodemath_parens(parameter_one, options: options)}̅"
        end

        protected

        def acc_tag(display_style, options:)
          acc = Utility.ox_element("acc", namespace: "m")
          chr = Utility.ox_element("chr", namespace: "m", attributes: { "m:val": "‾" } )
          acc_pr = (Utility.ox_element("accPr", namespace: "m") << chr)
          Utility.update_nodes(
            acc,
            [
              acc_pr,
              omml_parameter(parameter_one, display_style, tag_name: "e", options: options),
            ],
          )
          [acc]
        end

        def bar_tag(display_style, options:)
          bar = Utility.ox_element("bar", namespace: "m")
          Utility.update_nodes(
            bar,
            [
              bar_pr,
              omml_parameter(parameter_one, display_style, tag_name: "e", namespace: "m", options: options),
            ],
          )
          [bar]
        end

        def bar_pr
          attrs = { "m:val": "top" }
          barpr = Utility.ox_element("barPr", namespace: "m")
          pos   = Utility.ox_element("pos", namespace: "m", attributes: attrs)
          ctrlp = Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(barpr, [pos, ctrlp])
        end
      end

      Overline = Bar
    end
  end
end
