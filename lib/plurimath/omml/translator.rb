# frozen_string_literal: true

module Plurimath
  class Omml
    class Translator
      include Omml::FormulaTransformation

      FONT_STYLE_NAMES = {
        "sans-serif-bi" => "sans-serif-bold-italic",
        "double-struck" => "double-struck",
        "sans-serif-i" => "sans-serif-italic",
        "sans-serif-b" => "bold-sans-serif",
        "sans-serif-p" => "sans-serif",
        "fraktur-p" => "fraktur",
        "fraktur-b" => "bold-fraktur",
        "script-b" => "bold-script",
        "script-p" => "script",
        "monospace" => "monospace",
        "bi" => "bold-italic",
        "p" => "normal",
        "i" => "italic",
        "b" => "bold",
      }.freeze

      def omml_to_plurimath(node)
        return nil if node.nil?

        translate_node(node)
      end

      private

      # The OMML importer keeps this dispatcher explicit so unsupported typed
      # model classes fail at the boundary instead of silently falling through.
      # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
      def translate_node(node)
        return text_value_to_plurimath(node) if node.is_a?(String)
        return unsupported_node!(node) unless omml_model_node?(node)

        case node
        when ::Omml::Models::OMathPara
          flattened_formula_from_omml_children(node)
        when ::Omml::Models::OMath, ::Omml::Models::CTOMath
          formula_from_omml_children(node)
        when ::Omml::Models::CTOMathArg
          wrapped_omml_children(node)
        when ::Omml::Models::CTR
          run_to_plurimath(node)
        when ::Omml::Models::CTF then fraction_to_plurimath(node)
        when ::Omml::Models::CTSSup then superscript_to_plurimath(node)
        when ::Omml::Models::CTSSub then subscript_to_plurimath(node)
        when ::Omml::Models::CTSSubSup then sub_sup_to_plurimath(node)
        when ::Omml::Models::CTSPre then prescript_to_plurimath(node)
        when ::Omml::Models::CTRad then radical_to_plurimath(node)
        when ::Omml::Models::CTNary then nary_to_plurimath(node)
        when ::Omml::Models::CTD then delimiter_to_plurimath(node)
        when ::Omml::Models::CTEqArr then equation_array_to_plurimath(node)
        when ::Omml::Models::CTFunc then function_to_plurimath(node)
        when ::Omml::Models::CTLimUpp then upper_limit_to_plurimath(node)
        when ::Omml::Models::CTLimLow then lower_limit_to_plurimath(node)
        when ::Omml::Models::CTAcc then accent_to_plurimath(node)
        when ::Omml::Models::CTBar then bar_to_plurimath(node)
        when ::Omml::Models::CTBorderBox then border_box_to_plurimath(node)
        when ::Omml::Models::CTM then matrix_to_plurimath(node)
        when ::Omml::Models::CTMR then matrix_row_to_plurimath(node)
        when ::Omml::Models::CTGroupChr then group_character_to_plurimath(node)
        when ::Omml::Models::CTPhant then phantom_to_plurimath(node)
        when String then text_value_to_plurimath(node)
        when ::Omml::Models::CTText then typed_text_to_plurimath(node)
        when ::Omml::Models::CTFPr then nil
        when ::Omml::Models::CTRPr then word_run_properties_to_plurimath(node)
        when ::Omml::Models::CTRPR then math_run_properties_to_plurimath(node)
        else
          unsupported_node!(node)
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

      def omml_model_node?(node)
        node.class.name&.start_with?("Omml::Models::")
      end

      def text_value_to_plurimath(node)
        omml_text_value(node)
      end

      def typed_text_to_plurimath(node)
        omml_text_value(node.content.to_s)
      end

      def run_to_plurimath(node)
        children = ordered_omml_children(node).filter_map do |child|
          run_child_to_plurimath(node, child)
        end
        return nil if children.empty?

        return styled_run_to_plurimath(children) if styled_run?(children)

        Utility.filter_values(children)
      end

      def run_child_to_plurimath(node, child)
        return Math::Function::Linebreak.new if linebreak_child?(node, child)

        unwrap_single_child_formula(omml_to_plurimath(child))
      end

      def linebreak_child?(node, child)
        child == "" && node.respond_to?(:br) && node.br == ""
      end

      def styled_run?(children)
        children.length > 1 && !children.first.is_a?(Math::Core)
      end

      def styled_run_to_plurimath(children)
        font = children.shift
        font.new(
          Utility.filter_values(children),
          Utility::FONT_STYLES.key(font).to_s,
        )
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
        return script_function_to_plurimath(script_class, node) if script_class

        power_base_to_plurimath(base, node)
      end

      def script_function_to_plurimath(script_class, node)
        script_class.new(
          omml_argument_value(node.sub),
          omml_argument_value(node.sup),
        )
      end

      def power_base_to_plurimath(base, node)
        Math::Function::PowerBase.new(
          base,
          omml_argument_value(node.sub),
          omml_argument_value(node.sup),
        )
      end

      def script_class_for(base)
        return unless base && Utility.valid_class(base)

        Utility.get_class(base.extract_class_name_from_text)
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

        return ternary_nary_to_plurimath(symbol, node) if symbol.is_a?(Math::Function::TernaryFunction)

        fallback_nary_to_plurimath(node, character, properties)
      end

      def fallback_nary_to_plurimath(node, character, properties)
        Math::Function::Nary.new(
          nary_symbol(character),
          omml_argument_value(node.sub),
          omml_argument_value(node.sup),
          omml_argument_value(node.e),
          { type: nary_type(properties) },
        )
      end

      def ternary_nary_to_plurimath(symbol, node)
        symbol.parameter_one = omml_argument_value(node.sub)
        symbol.parameter_two = omml_argument_value(node.sup)
        symbol.parameter_three = omml_argument_value(node.e)
        symbol
      end

      def delimiter_to_plurimath(node)
        properties = first_omml_child(node.d_pr)
        open_paren, close_paren = delimiter_parens(properties)
        children = delimiter_children(node)

        table = delimited_table(children, open_paren, close_paren)
        return table if table

        fenced_to_plurimath(open_paren, children, close_paren, properties)
      end

      def fenced_to_plurimath(open_paren, children, close_paren, properties)
        fenced = Math::Function::Fenced.new(open_paren, children, close_paren)
        sep_chr = first_omml_child(properties&.sep_chr)
        fenced.options = sep_chr ? { sepChr: sep_chr.val } : nil
        fenced
      end

      def delimiter_parens(properties)
        [
          delimiter_boundary(first_omml_child(properties&.beg_chr), "("),
          delimiter_boundary(first_omml_child(properties&.end_chr), ")"),
        ]
      end

      def delimiter_children(node)
        node.e.flat_map { |child| omml_argument_values(child) }.compact
      end

      def delimited_table(children, open_paren, close_paren)
        return unless children.length == 1 && children.first.is_a?(Math::Function::Table)

        children.first.tap do |table|
          table.open_paren = open_paren
          table.close_paren = close_paren
        end
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
        accent_to_math_function(value)
      end

      def accent_to_math_function(value)
        accent = value.first
        unless accent.is_a?(Math::Function::UnaryFunction)
          return Math::Function::Overset.new(accent, value.last, { accent: true })
        end

        accent.attributes = { accent: true }
        accent
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

        return group_character_above(chr, value) if group_character_above?(pr)

        group_character_below(chr, value)
      end

      def group_character_above?(properties)
        first_omml_child(properties&.pos)&.val == "top"
      end

      def group_character_above(chr, value)
        Math::Function::Overset.new(
          Math::Symbols::Symbol.new(chr || ""),
          value,
        )
      end

      def group_character_below(chr, value)
        Math::Function::Underset.new(
          Math::Symbols::Symbol.new(chr || "⏟"),
          value,
        )
      end

      def phantom_to_plurimath(node)
        omml_argument_value(node.e)
      end

      def word_run_properties_to_plurimath(node)
        bold = enabled_omml_property?(first_omml_child(node.b))
        italic = enabled_omml_property?(first_omml_child(node.i))

        return Utility::FONT_STYLES[:"bold-italic"] if bold && italic
        return Utility::FONT_STYLES[:bold] if bold
        return Utility::FONT_STYLES[:italic] if italic

        nil
      end

      def math_run_properties_to_plurimath(node)
        font_key = [
          first_omml_child(node.scr)&.val,
          first_omml_child(node.sty)&.val,
        ].compact.join("-")
        return if font_key.empty?

        supported_font = FONT_STYLE_NAMES[font_key]
        Utility::FONT_STYLES[supported_font&.to_sym]
      end

      def nary_symbol(chr)
        Utility.symbols_class(
          Utility.string_to_html_entity(chr || "∫"),
          lang: :omml,
        )
      end

      def nary_character(properties)
        properties && first_omml_child(properties.chr)&.val
      end

      def nary_operator(character)
        character && Utility.mathml_unary_classes([character], lang: :omml)
      end

      def nary_type(properties)
        first_omml_child(properties&.lim_loc)&.val || "subSup"
      end

      def delimiter_symbol(value)
        return if value.nil? || value.empty?

        Utility.symbol_object(Utility.string_to_html_entity(value), lang: :omml)
      end

      def delimiter_boundary(character, default_value)
        return delimiter_symbol(default_value) unless character

        delimiter_symbol(character.val)
      end
    end
  end
end
