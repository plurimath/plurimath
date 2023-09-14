# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Table < Core
        attr_accessor :value, :open_paren, :close_paren, :options

        SIMPLE_TABLES = %w[array align split].freeze

        def initialize(value = nil,
                       open_paren = nil,
                       close_paren = nil,
                       options = {})
          @value = value
          @open_paren = open_paren
          @close_paren = close_paren
          @options = options
        end

        def ==(object)
          object.class == self.class &&
            object.value == value &&
            object.options == options &&
            object.open_paren == open_paren &&
            object.close_paren == close_paren
        end

        def to_asciimath
          return parentheless_table if SIMPLE_TABLES.include?(class_name)

          parenthesis = Asciimath::Constants::TABLE_PARENTHESIS
          first_value = value.map(&:to_asciimath).join(", ")
          third_value = close_paren.is_a?(::Array) || close_paren.nil?
          lparen = open_paren.nil? ? "[" : open_paren
          rparen = third_value ? parenthesis[lparen.to_sym] : close_paren
          "#{lparen}#{first_value}#{rparen}"
        end

        def to_mathml_without_math_tag
          table_tag = Utility.ox_element("mtable", attributes: table_attribute)
          Utility.update_nodes(
            table_tag,
            value&.map(&:to_mathml_without_math_tag),
          )
          return norm_table(table_tag) if open_paren == "norm["

          if present?(open_paren) || present?(close_paren)
            first_paren = Utility.ox_element("mo") << mathml_parenthesis(open_paren)
            second_paren = Utility.ox_element("mo") << mathml_parenthesis(close_paren)
            mrow_tag = Utility.ox_element("mrow")
            return Utility.update_nodes(mrow_tag, [first_paren, table_tag, second_paren])
          end

          table_tag
        end

        def to_latex
          return "\\begin{Vmatrix}#{latex_content}\\end{Vmatrix}" if open_paren == "norm["

          separator = "{#{table_attribute(:latex)}}" if environment&.include?("array")
          left_paren = latex_parenthesis(open_paren)
          right_paren = latex_parenthesis(close_paren)
          left = "\\left #{left_paren}\\begin{matrix}"
          right = "\\end{matrix}\\right #{right_paren}"
          "#{left}#{separator}#{latex_content}#{right}"
        end

        def to_html
          first_value = value.map(&:to_html).join
          "<table>#{first_value}</table>"
        end

        def to_omml_without_math_tag(display_style)
          ox_table = if value.map { |d| d.parameter_one.length == 1 }.all?
                       single_td_table(display_style)
                     else
                       multiple_td_table(display_style)
                     end
          fenced_table(ox_table)
        end

        def to_asciimath_math_zone(spacing, last = false, indent = true)
          [
            "#{spacing}\"table\" function apply\n",
            Formula.new(value).to_asciimath_math_zone(gsub_spacing(spacing, last), last, indent),
          ]
        end

        def to_latex_math_zone(spacing, last = false, indent = true)
          [
            "#{spacing}\"table\" function apply\n",
            Formula.new(value).to_latex_math_zone(gsub_spacing(spacing, last), last, indent),
          ]
        end

        def to_mathml_math_zone(spacing, last = false, indent = true)
          [
            "#{spacing}\"table\" function apply\n",
            Formula.new(value).to_mathml_math_zone(gsub_spacing(spacing, last), last, indent),
          ]
        end

        def to_omml_math_zone(spacing, last = false, indent = true, display_style:)
          [
            "#{spacing}\"table\" function apply\n",
            Formula.new(value).to_omml_math_zone(gsub_spacing(spacing, last), last, indent, display_style: display_style),
          ]
        end

        protected

        def present?(field)
          !(field.nil? || field.empty?)
        end

        def mathml_parenthesis(field)
          return "" if field&.include?(":")

          present?(field) ? field : ""
        end

        def latex_parenthesis(field)
          return "." unless field
          return " ." if field&.include?(":")

          return "\\#{field}" if ["{", "}"].include?(field)

          field
        end

        def table_attribute(type = :mathml)
          column_string = column_lines
          case type
          when :mathml
            mathml_attrs(column_string)
          when :latex
            column_string.insert(0, "none") if column_string.include?("solid")
            column_string&.map { |d| d == "solid" ? "|" : "a" }&.join
          end
        end

        def column_lines
          columns_array = []
          value.first.parameter_one.each_with_index do |td, i|
            if td.parameter_one.find { |obj| Utility.symbol_value(obj, "|") }
              columns_array.empty? ? columns_array = ["solid"] : columns_array[i - 1] = "solid"
            else
              columns_array << "none"
            end
          end
          columns_array
        end

        def mathml_attrs(column_strings)
          args = options&.dup&.reject { |arg| arg.to_s == "asterisk" }
          args[:columnlines] = column_strings.join(" ") if column_strings.include?("solid")
          args[:columnalign] = "left" if close_paren&.include?(":}")
          args
        end

        def latex_content
          value&.map(&:to_latex)&.join(" \\\\ ")
        end

        def matrix_class
          matrix = if open_paren
                     Latex::Constants::MATRICES.invert[open_paren]
                   else
                     class_name
                   end
          options&.key?(:asterisk) ? "{#{matrix}*}" : "{#{matrix}}"
        end

        def opening
          "#{matrix_class}#{latex_columnalign}"
        end

        def latex_columnalign
          return "" unless Hash(options)[:asterisk]

          "[#{Utility::ALIGNMENT_LETTERS.invert[Hash(td_hash)[:columnalign]]}]"
        end

        def td_hash
          value&.first&.parameter_one&.first&.parameter_two
        end

        def environment
          matrices_hash = Latex::Constants::MATRICES
          matric_value  = matrices_hash.value?(open_paren)
          matrices_hash.invert[open_paren].to_s if matric_value
        end

        def single_td_table(display_style)
          eqarr    = Utility.ox_element("eqArr", namespace: "m")
          eqarrpr  = Utility.ox_element("eqArrPr", namespace: "m")
          eqarrpr  << Utility.pr_element("ctrl", true, namespace: "m")
          eqarr    << eqarrpr
          tr_value = value.map { |object| object.to_omml_without_math_tag(display_style) }.flatten
          Utility.update_nodes(eqarr, tr_value.compact)
          [eqarr]
        end

        def multiple_td_table(display_style)
          count  = { "m:val": value&.first&.parameter_one&.count }
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
          mm_value = value&.map { |object| object.to_omml_without_math_tag(display_style) }
          Utility.update_nodes(
            mm,
            mm_value.insert(0, mpr).flatten,
          )
          [mm]
        end

        def norm_table(table_tag)
          mo_tag = Utility.ox_element("mo") << "&#x2225;"
          Utility.update_nodes(
            Utility.ox_element("mrow"),
            [
              mo_tag,
              table_tag,
              mo_tag,
            ],
          )
        end

        def fenced_table(ox_table)
          return ox_table unless open_paren || close_paren

          d_node = Utility.ox_element("d", namespace: "m")
          e_node = Utility.ox_element("e", namespace: "m")
          Utility.update_nodes(e_node, ox_table)
          Utility.update_nodes(d_node, [mdpr_node, e_node])
          [d_node]
        end

        def mdpr_node
          sepchr = Utility.ox_element("sepChr", attributes: { "m:val": "" }, namespace: "m")
          mgrow  = Utility.ox_element("grow", namespace: "m")
          mdpr = Utility.ox_element("dPr", namespace: "m")
          Utility.update_nodes(mdpr, [begchr, endchr, sepchr, mgrow])
        end

        def begchr
          return unless open_paren

          Utility.ox_element("begChr", attributes: { "m:val": paren(open_paren) }, namespace: "m")
        end

        def endchr
          return unless close_paren

          Utility.ox_element("endChr", attributes: { "m:val": paren(close_paren) }, namespace: "m")
        end

        def paren(parenthesis)
          return "" if ["{:", ":}"].include?(parenthesis)

          parenthesis
        end

        def parentheless_table
          "{:#{value.map(&:to_asciimath).join(", ")}:}"
        end
      end
    end
  end
end
