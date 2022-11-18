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
          first_value = parameter_one.map(&:to_asciimath).join(",")
          left_paren  = parameter_two.nil? ? "[" : parameter_two
          right_paren = parameter_three.nil? ? "]" : parameter_three
          "#{left_paren}#{first_value}#{right_paren}"
        end

        def to_mathml_without_math_tag
          table_value = parameter_one.map(&:to_mathml_without_math_tag)
          parenthesis = Latex::Constants::PARENTHESIS
          table_tag   = Utility.ox_element("mtable", attributes: table_columnlines_attribute)
          Utility.update_nodes(table_tag, table_value)
          if parenthesis.key?(parameter_two) || parameter_two == "|"
            Utility.ox_element(
              "mfenced",
              attributes: { open: parameter_two, close: parameter_three },
            ) << table_tag
          elsif parameter_two == "norm["
            row_tag = Utility.ox_element("mrow")
            mo_tag  = Utility.ox_element("mo") << "&#x2225;"
            Utility.update_nodes(
              row_tag,
              [
                mo_tag,
                table_tag,
                mo_tag,
              ],
            )
          else
            table_tag
          end
        end

        def table_columnlines_attribute
          column_lines = []
          parameter_one.first.parameter_one.each_with_index do |td, i|
            if td.parameter_one.find { |obj| obj.is_a?(Symbol) && obj.value == "|" }
              column_lines[i - 1] = "solid"
            else
              column_lines << "none"
            end
          end
          column_lines.include?("solid") ? { columnlines: column_lines.join(' ') } : {}
        end

        def to_latex
          first_value = parameter_one&.map(&:to_latex)&.join("\\\\")
          environment = latex_environment
          "\\begin{#{environment}}#{first_value}\\end{#{environment}}"
        end

        def latex_environment
          matrices_hash = Latex::Constants::MATRICES
          matric_value  = matrices_hash.value?(parameter_two)
          matrices_hash.invert[parameter_two] if matric_value
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

        def single_td_table
          eqarr    = Utility.ox_element("eqArr", namespace: "m")
          eqarrpr  = Utility.ox_element("eqArrPr", namespace: "m")
          eqarrpr  << Utility.pr_element("ctrl", true, namespace: "m")
          eqarr    << eqarrpr
          tr_value = parameter_one.map(&:to_omml_without_math_tag)
          Utility.update_nodes(
            eqarr,
            tr_value.flatten.compact,
          )
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
          mm_value = parameter_one.map(&:to_omml_without_math_tag)
          Utility.update_nodes(mm, mm_value.insert(0, mpr))
        end
      end
    end
  end
end
