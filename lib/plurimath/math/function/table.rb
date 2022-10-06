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
          first_value  = parameter_one.map(&:to_asciimath).join(",")
          second_value = parameter_two.nil? ? "[" : parameter_two
          third_value  = parameter_three.nil? ? "]" : parameter_three
          "#{second_value}#{first_value}#{third_value}"
        end

        def to_mathml_without_math_tag
          table_value = parameter_one.map(&:to_mathml_without_math_tag).join
          parenthesis = Latex::Constants::PARENTHESIS
          if parenthesis.key?(parameter_two) || parameter_two == "|"
            "<mfenced open='#{parameter_two}' close='#{parameter_three}'>"\
              "<mtable>#{table_value}</mtable></mfenced>"
          elsif parameter_two == "norm["
            "<mo>&#x2225;</mo>#{table_value}<mo>&#x2225;</mo>"
          else
            "<mtable>#{table_value}</mtable>"
          end
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
          eqarr    = Utility.omml_element("m:eqArr")
          eqarrpr  = Utility.omml_element("m:eqArrPr")
          eqarrpr  << Utility.pr_element("m:ctrl", true)
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
          mm     = Utility.omml_element("m:m")
          mpr    = Utility.omml_element("m:mpr")
          mcs    = Utility.omml_element("m:mcs", true)
          mc     = Utility.omml_element("m:mc", true)
          mcpr   = Utility.pr_element("m:mcPr", true)
          mcount = Utility.omml_element("m:count", count)
          mcjc   = Utility.omml_element("m:mcJc", mcjc)
          ctrlpr = Utility.pr_element("m:ctrl", true)
          Utility.update_nodes(mcpr, [mcount, mcjc])
          mcs      << mc << mcpr
          mpr      << mcs
          mpr      << ctrlpr
          mm_value = parameter_one.map(&:to_omml_without_math_tag)
          Utility.update_nodes(mm, mm_value)
        end
      end
    end
  end
end
