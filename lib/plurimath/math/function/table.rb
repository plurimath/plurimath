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
          @open_paren = Utility.symbols_class(open_paren, lang: :unicodemath)
          @close_paren = Utility.symbols_class(close_paren, lang: :unicodemath)
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
          lparen = open_paren.nil? ? "[" : open_paren.to_asciimath
          rparen = close_paren.nil? ? parenthesis[lparen.to_sym] : close_paren.to_asciimath
          "#{lparen}#{first_value}#{rparen}"
        end

        def to_mathml_without_math_tag(intent)
          table_tag = ox_element("mtable", attributes: table_attribute)
          table_tag["intent"] = ":matrix(#{value.length},#{td_count})" if intent
          Utility.update_nodes(
            table_tag,
            value&.map { |object| object&.to_mathml_without_math_tag(intent) },
          )
          return norm_table(table_tag) if open_paren.is_a?(Math::Symbols::Paren::Norm)

          if mathml_paren_present?(open_paren, intent) || mathml_paren_present?(close_paren, intent)
            first_paren = mo_element(mathml_parenthesis(open_paren, intent))
            second_paren = mo_element(mathml_parenthesis(close_paren, intent))
            attributes = { intent: ":fenced" } if intent
            mrow = ox_element("mrow", attributes: attributes)
            return Utility.update_nodes(mrow, [first_paren, table_tag, second_paren])
          end

          table_tag
        end

        def to_latex
          return "\\begin{Vmatrix}#{latex_content}\\end{Vmatrix}" if open_paren.is_a?(Math::Symbols::Paren::Norm)

          separator = "{#{table_attribute(:latex)}}" if environment&.include?("array")
          left_paren = open_paren&.to_latex || "."
          right_paren = close_paren&.to_latex || "."
          left = "\\left #{left_paren}\\begin{matrix}"
          right = "\\end{matrix}\\right #{right_paren.delete_prefix("\\right")}"
          "#{left}#{separator}#{latex_content}#{right}"
        end

        def to_html
          first_value = value.map(&:to_html).join
          "<table>#{first_value}</table>"
        end

        def to_omml_without_math_tag(display_style)
          ox_table = if single_table?
                       single_td_table(display_style)
                     else
                       multiple_td_table(display_style)
                     end
          fenced_table(ox_table)
        end

        def to_unicodemath
          if unicodemath_table_class?
            "#{unicodemath_class_name}(#{value.map(&:to_unicodemath).join("@")})"
          else
            "#{open_paren&.to_unicodemath}■(#{value.map(&:to_unicodemath).join("@")})#{close_paren&.to_unicodemath}"
          end
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

        def mathml_parenthesis(field, intent)
          return "" unless field
          if field&.class_name == "symbol"
            paren = field&.to_mathml_without_math_tag(intent)&.nodes&.first
            return invisible_paren?(paren) ? "" : paren.to_s
          end

          paren = field&.respond_to?(:encoded) ? field&.encoded : field&.paren_value
          invisible_paren?(paren) ? "" : paren
        end

        def table_attribute(type = :mathml)
          column_string = column_lines
          case type
          when :mathml
            mathml_attrs(column_string)
          when :latex
            column_string.insert(0, "none") if column_string.include?("solid")
            column_string&.map { |str| str == "solid" ? "|" : "a" }&.join
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
          args[:columnalign] = "left" if close_paren.is_a?(Math::Symbols::Paren::CloseParen)
          args
        end

        def latex_content
          value&.map(&:to_latex)&.join(" \\\\ ")
        end

        def matrix_class
          matrix = if open_paren
                     Latex::Constants::MATRICES.invert[open_paren.to_matrices]
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
          mpr    = Utility.ox_element("mPr", namespace: "m")
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
          Utility.update_nodes(
            ox_element("mrow"),
            [
              mo_element("&#x2016;"),
              table_tag,
              mo_element("&#x2016;"),
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
          parenthesis.to_omml_without_math_tag(true)
        end

        def parentheless_table
          "{:#{value.map(&:to_asciimath).join(", ")}:}"
        end

        def single_table?
          value.map { |d| d.parameter_one.length == 1 }.all? &&
            nil_option?(:frame) &&
            nil_option?(:columnlines) &&
            nil_option?(:rowlines)
        end

        def nil_option?(option)
          options[option].nil? ||
            options[option] == "" ||
            options[option] == "none"
        end

        def invisible_paren?(paren)
          ["&#x3016;", "&#x3017;", "&#x2524;", "&#x251c;"].include?(paren)
        end

        def mo_element(value)
          Utility.ox_element("mo") << value
        end

        def unicodemath_table_class?
          return unless class_name == "table"
          return if open_paren.nil? && close_paren.nil?

          (!open_paren.nil? && !close_paren.nil?) ||
            Utility::PARENTHESIS[unicodemath_field_value(open_paren)] == close_paren ||
            [open_paren, close_paren].all?(Math::Symbols::Paren::Vert)
        end

        def unicodemath_class_name
          return matrices_functions(:Vmatrix) if class_name == "vmatrix" && open_paren&.class_name&.is_a?(Math::Symbols::Paren::Norm)
          return matrices_functions(:vmatrix) if [open_paren, close_paren].all?(Math::Symbols::Paren::Vert)
          return matrices_functions(:matrix) if class_name == "Bmatrix" && open_paren == Math::Symbols::Paren::Lcurly
          return unless unicodemath_table_class?

          matrix_name = UnicodeMath::Constants::PARENTHESIS_MATRICES.key(open_paren.to_unicodemath)
          matrices_functions(matrix_name)
        end

        def matrices_functions(matrix_name)
          UnicodeMath::Constants::MATRIXS[matrix_name]
        end

        def mathml_paren_present?(paren, intent)
          return unless paren || paren&.class_name == "symbol"

          !paren&.to_mathml_without_math_tag(intent)&.nodes&.first&.empty?
        end

        def td_count
          value&.first&.parameter_one&.length
        end
      end
    end
  end
end
