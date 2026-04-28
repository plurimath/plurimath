# frozen_string_literal: true

module Plurimath
  class Omml
    class Translator
      include Omml::FormulaTransformation

      def omml_to_plurimath(node)
        return nil if node.nil?

        translate_node(node)
      end

      private

      # The OMML importer keeps this dispatcher explicit so unsupported typed
      # model classes fail at the boundary instead of silently falling through.
      # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
      def translate_node(node)
        case node
        when String
          omml_text_value(node)
        else
          translate_omml_node(node)
        end
      end

      def translate_omml_node(node)
        # Use class names here so unsupported non-OMML inputs do not force
        # early OMML model autoload before the parser context is populated.
        case Lutaml::Model::Utils.base_class_name(node.class.name)
        when "OMathPara" then flattened_formula_from_omml_children(node)
        when "OMath", "CTOMath" then formula_from_omml_children(node)
        when "CTOMathArg" then wrapped_omml_children(node)
        when "CTR" then run_to_plurimath(node)
        when "CTF" then fraction_to_plurimath(node)
        when "CTSSup" then superscript_to_plurimath(node)
        when "CTSSub" then subscript_to_plurimath(node)
        when "CTSSubSup" then sub_sup_to_plurimath(node)
        when "CTSPre" then prescript_to_plurimath(node)
        when "CTRad" then radical_to_plurimath(node)
        when "CTNary" then nary_to_plurimath(node)
        when "CTD" then delimiter_to_plurimath(node)
        when "CTEqArr" then equation_array_to_plurimath(node)
        when "CTFunc" then function_to_plurimath(node)
        when "CTLimUpp" then upper_limit_to_plurimath(node)
        when "CTLimLow" then lower_limit_to_plurimath(node)
        when "CTAcc" then accent_to_plurimath(node)
        when "CTBar" then bar_to_plurimath(node)
        when "CTBorderBox" then border_box_to_plurimath(node)
        when "CTM" then matrix_to_plurimath(node)
        when "CTMR" then matrix_row_to_plurimath(node)
        when "CTGroupChr" then group_character_to_plurimath(node)
        when "CTPhant" then phantom_to_plurimath(node)
        when "CTText" then typed_text_to_plurimath(node)
        when "CTFPr" then nil
        when "CTRPr" then word_run_properties_to_plurimath(node)
        when "CTRPR" then math_run_properties_to_plurimath(node)
        else
          unsupported_node!(node)
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

      def typed_text_to_plurimath(node)
        omml_text_value(node.content.to_s)
      end

      def run_to_plurimath(node)
        children = ordered_omml_children(node).filter_map do |child|
          run_child_value(node, child)
        end
        return nil if children.empty?

        return styled_run_value(children) if styled_run?(children)

        Utility.filter_values(children)
      end

      def fraction_to_plurimath(node)
        Math::Function::Frac.new(
          unwrap_single_child_formula(omml_to_plurimath(node.num)),
          unwrap_single_child_formula(omml_to_plurimath(node.den)),
        )
      end

      def superscript_to_plurimath(node)
        Math::Function::Power.new(
          omml_argument_value(node.e),
          omml_argument_value(node.sup),
        )
      end

      def subscript_to_plurimath(node)
        Math::Function::Base.new(
          omml_argument_value(node.e),
          omml_argument_value(node.sub),
        )
      end

      def sub_sup_to_plurimath(node)
        base = omml_argument_value(node.e)
        script_class = script_class_for(base)
        return script_function_value(script_class, node) if script_class

        power_base_value(base, node)
      end

      def prescript_to_plurimath(node)
        Math::Function::Multiscript.new(
          omml_argument_value(node.e),
          Array(omml_argument_value(node.sub)),
          Array(omml_argument_value(node.sup)),
        )
      end

      def radical_to_plurimath(node)
        degree = omml_argument_value(node.deg)
        radicand = omml_argument_value(node.e)

        if degree.nil?
          Math::Function::Sqrt.new(radicand)
        else
          Math::Function::Root.new(degree, radicand)
        end
      end

      def nary_to_plurimath(node)
        properties = first_omml_child(node.nary_pr)
        character = nary_character(properties)
        symbol = nary_operator(character)

        return ternary_nary_value(symbol, node) if symbol.is_a?(Math::Function::TernaryFunction)

        nary_value(node, character, properties)
      end

      def delimiter_to_plurimath(node)
        properties = first_omml_child(node.d_pr)
        open_paren, close_paren = delimiter_parens(properties)
        children = delimiter_children(node)

        table = delimited_table(children, open_paren, close_paren)
        return table if table

        fenced_value(open_paren, children, close_paren, properties)
      end

      def equation_array_to_plurimath(node)
        Math::Function::Table.new(
          node.e.map do |child|
            Math::Function::Tr.new(
              [
                Math::Function::Td.new(omml_argument_values(child).compact),
              ],
            )
          end,
        )
      end

      def function_to_plurimath(node)
        Utility.filter_values(
          Utility.populate_function_classes(
            [
              omml_argument_value(node.f_name),
              omml_argument_value(node.e),
            ],
            lang: :omml,
          ),
        )
      end

      def upper_limit_to_plurimath(node)
        base = omml_argument_value(node.e)
        limit = omml_argument_value(node.lim)

        if empty_unary_function?(limit)
          limit.parameter_one = base
          limit
        else
          Math::Function::Overset.new(base, limit)
        end
      end

      def lower_limit_to_plurimath(node)
        base = omml_argument_value(node.e)
        limit = omml_argument_value(node.lim)

        if empty_unary_function?(limit)
          limit.parameter_one = base
          limit
        else
          Math::Function::Underset.new(base, limit)
        end
      end

      def accent_to_plurimath(node)
        pr = first_omml_child(node.acc_pr)
        chr = first_omml_child(pr&.chr)&.val
        accent = chr ? Utility.mathml_unary_classes([chr], lang: :omml) : Math::Function::Hat.new
        value = [accent, omml_argument_value(node.e)]
        Utility.unary_function_classes(value, lang: :omml)
        accent_value(value)
      end

      def bar_to_plurimath(node)
        Math::Function::Bar.new(
          omml_argument_value(node.e),
          { accent: false },
        )
      end

      def border_box_to_plurimath(node)
        Math::Function::Menclose.new(
          "longdiv",
          omml_argument_value(node.e),
        )
      end

      def matrix_to_plurimath(node)
        Math::Function::Table.new(
          node.mr.map { |row| matrix_row_to_plurimath(row) },
        )
      end

      def matrix_row_to_plurimath(node)
        Math::Function::Tr.new(
          node.e.map do |cell|
            Math::Function::Td.new(omml_argument_values(cell).compact)
          end,
        )
      end

      def group_character_to_plurimath(node)
        pr = first_omml_child(node.group_chr_pr)
        chr = first_omml_child(pr&.chr)&.val
        value = omml_argument_value(node.e)

        return group_character_above_value(chr, value) if group_character_above?(pr)

        group_character_below_value(chr, value)
      end

      def phantom_to_plurimath(node)
        omml_argument_value(node.e)
      end

      def word_run_properties_to_plurimath(node)
        word_run_font(node)
      end

      def math_run_properties_to_plurimath(node)
        math_run_font(node)
      end
    end
  end
end
