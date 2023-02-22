# frozen_string_literal: true

require_relative "ternary_function"

module Plurimath
  module Math
    module Function
      class Table < TernaryFunction
        def initialize(parameter_one = nil,
                       parameter_two = nil,
                       parameter_three = nil)
          super
        end

        def to_asciimath
          parenthesis = Asciimath::Constants::TABLE_PARENTHESIS
          first_value = parameter_one.map(&:to_asciimath).join(", ")
          third_value = parameter_three.is_a?(::Array) || parameter_three.nil?
          lparen = parameter_two.nil? ? "[" : parameter_two
          rparen = third_value ? parenthesis[lparen.to_sym] : parameter_three
          "#{lparen}#{first_value}#{rparen}"
        end

        def to_mathml_without_math_tag
          table_tag = Utility.ox_element("mtable", attributes: table_attribute)
          Utility.update_nodes(
            table_tag,
            parameter_one&.map(&:to_mathml_without_math_tag),
          )
          return norm_table(table_tag) if parameter_two == "norm["

          if present?(parameter_two) || present?(parameter_three)
            attributes = {
              open: mathml_parenthesis(parameter_two),
              close: mathml_parenthesis(parameter_three),
            }
            Utility.ox_element("mfenced", attributes: attributes) << table_tag
          else
            table_tag
          end
        end

        def to_latex
          if parameter_two == "norm["
            return "\\begin{Vmatrix}#{latex_content}\\end{Vmatrix}"
          end

          separator = "{#{table_attribute(:latex)}}" if environment.include?("array")
          left_paren = latex_parenthesis(parameter_two) || "."
          right_paren = latex_parenthesis(parameter_three) || "."
          left = "\\left #{left_paren}\\begin{matrix}"
          right = "\\end{matrix}\\right #{right_paren}"
          "#{left}#{separator}#{latex_content}#{right}"
        end

        def to_html
          first_value = parameter_one.map(&:to_html).join
          "<table>#{first_value}</table>"
        end

        def to_omml_without_math_tag
          if parameter_one.map { |d| d.parameter_one.length == 1 }.all?
            single_td_table
          else
            multiple_td_table
          end
        end

        protected

        def present?(field)
          !(field.nil? || field.empty?)
        end

        def mathml_parenthesis(field)
          return "" if field&.include?(":")

          field
        end

        def latex_parenthesis(field)
          return " ." if field&.include?(":")

          return "\\#{field}" if ["{", "}"].include?(field)

          field
        end

        def table_attribute(type = :mathml)
          column_lines = []
          parameter_one.first.parameter_one.each_with_index do |td, i|
            if td.parameter_one.find { |obj| Utility.symbol_value(obj, "|") }
              column_lines[i - 1] = "solid"
            else
              column_lines << "none"
            end
          end
          case type
          when :mathml
            column_lines.include?("solid") ? { columnlines: column_lines.join(" ") } : {}
          when :latex
            column_lines.insert(0, "none") if column_lines.include?("solid")
            column_lines&.map { |d| d == "solid" ? "|" : "a" }&.join
          end
        end

        def latex_content
          parameter_one&.map(&:to_latex)&.join(" \\\\ ")
        end

        def matrix_class
          if parameter_two
            return Latex::Constants::MATRICES.invert[parameter_two]
          end

          class_name
        end

        def matrix?
          parameter_three.nil? || (parameter_three.is_a?(::Array) && !parameter_three.empty?)
        end

        def opening
          args = parameter_three.map(&:to_latex).join if matrix?
          matrix? && args ? "{#{matrix_class}*}[#{args}]" : "{#{matrix_class}}"
        end

        def ending
          matrix? ? "{#{matrix_class}*}" : "{#{matrix_class}}"
        end

        def environment
          matrices_hash = Latex::Constants::MATRICES
          matric_value  = matrices_hash.value?(parameter_two)
          matrices_hash.invert[parameter_two].to_s if matric_value
        end

        def single_td_table
          eqarr    = Utility.ox_element("eqArr", namespace: "m")
          eqarrpr  = Utility.ox_element("eqArrPr", namespace: "m")
          eqarrpr  << Utility.pr_element("ctrl", true, namespace: "m")
          eqarr    << eqarrpr
          tr_value = parameter_one.map(&:to_omml_without_math_tag).flatten
          Utility.update_nodes(eqarr, tr_value.compact)
        end

        def multiple_td_table
          count  = { "m:val": parameter_one&.first&.parameter_one&.count }
          mcjc   = { "m:val": "center" }
          mm     = Utility.ox_element("m", namespace: "m")
          mpr    = Utility.ox_element("mpr", namespace: "m")
          mcs    = Utility.ox_element("mcs", namespace: "m")
          mc     = Utility.ox_element("mc", namespace: "m")
          mcpr   = Utility.ox_element("mcPr", namespace: "m")
          mcount = Utility.ox_element(
            "count",
            namespace: "m",
            attributes: count,
          )
          mcjc = Utility.ox_element(
            "mcJc",
            namespace: "m",
            attributes: mcjc,
          )
          ctrlpr = Utility.pr_element("ctrl", true, namespace: "m")
          Utility.update_nodes(mcpr, [mcount, mcjc])
          mc  << mcpr
          mcs << mc
          mpr << mcs
          mpr << ctrlpr
          mm_value = parameter_one&.map(&:to_omml_without_math_tag)
          Utility.update_nodes(mm, mm_value.insert(0, mpr).flatten)
        end

        def norm_table(table_tag)
          mo_tag = Utility.ox_element("mo") << "&#x2225;"
          Utility.update_nodes(
            Utility.ox_element("mrow"),
            [mo_tag, table_tag, mo_tag],
          )
        end
      end
    end
  end
end
