# frozen_string_literal: true

module Plurimath
  class Omml
    module FormulaTransformation
      private

      # OMML typed models expose children through mapped accessors, but
      # document order lives in `element_order`. Rebuild that order first so
      # translation stays faithful to the original XML sequence.
      def ordered_omml_children(node)
        return [] unless node.respond_to?(:element_order)

        mapped_children = mapped_children_by_omml_name(node)

        node.element_order.each_with_object([]) do |element, children|
          next unless element.node_type == :element

          child = consume_ordered_child(mapped_children, element.name.to_sym)
          children << child if child
        end
      end

      def translated_omml_children(node)
        ordered_omml_children(node).filter_map do |child|
          unwrap_single_child_formula(omml_to_plurimath(child))
        end
      end

      def formula_from_omml_children(node)
        Math::Formula.new(translated_omml_children(node))
      end

      def flattened_formula_from_omml_children(node)
        Math::Formula.new(
          translated_omml_children(node).flat_map do |child|
            child.is_a?(Math::Formula) ? child.value : child
          end,
        )
      end

      def wrapped_omml_children(node)
        children = translated_omml_children(node)

        case children.length
        when 0 then nil
        when 1 then children.first
        else Math::Formula.new(children)
        end
      end

      def unwrap_single_child_formula(value)
        return nil if value.nil?
        return value unless value.is_a?(Math::Formula)
        return value if value.value.nil? || value.value.empty?

        value.value.length == 1 ? value.value.first : value
      end

      def omml_text_value(value)
        value = value.gsub("&nbsp;", "\u00A0")
        return Math::Function::Text.new("", lang: :omml) if value == ""
        return nil if value == "\u200B"

        Utility.mathml_unary_classes([value], omml: true, lang: :omml)
      end

      def omml_argument_value(node)
        unwrap_single_child_formula(omml_to_plurimath(node))
      end

      def omml_argument_values(node)
        value = omml_argument_value(node)
        return value.value if value.is_a?(Math::Formula)

        Array(value)
      end

      def first_omml_child(value)
        Array(value).first
      end

      def enabled_omml_property?(property)
        return false unless property

        !%w[0 false off].include?(property.val.to_s)
      end

      def empty_unary_function?(value)
        value.respond_to?(:is_unary?) && value.is_unary? &&
          value.respond_to?(:value_nil?) && value.value_nil?
      end

      def unsupported_node!(node)
        raise UnsupportedNodeError, node
      end

      def run_child_value(node, child)
        return Math::Function::Linebreak.new if linebreak_child?(node, child)

        unwrap_single_child_formula(omml_to_plurimath(child))
      end

      def linebreak_child?(node, child)
        child == "" && node.respond_to?(:br) && node.br == ""
      end

      def styled_run?(children)
        children.length > 1 && !children.first.is_a?(Math::Core)
      end

      def styled_run_value(children)
        font = children.first
        font.new(
          Utility.filter_values(children.drop(1)),
          Utility::FONT_STYLES.key(font).to_s,
        )
      end

      def script_function_value(script_class, node)
        script_class.new(
          omml_argument_value(node.sub),
          omml_argument_value(node.sup),
        )
      end

      def power_base_value(base, node)
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

      def nary_value(node, character, properties)
        Math::Function::Nary.new(
          nary_symbol(character),
          omml_argument_value(node.sub),
          omml_argument_value(node.sup),
          omml_argument_value(node.e),
          { type: nary_type(properties) },
        )
      end

      def ternary_nary_value(symbol, node)
        symbol.parameter_one = omml_argument_value(node.sub)
        symbol.parameter_two = omml_argument_value(node.sup)
        symbol.parameter_three = omml_argument_value(node.e)
        symbol
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

      def fenced_value(open_paren, children, close_paren, properties)
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

      def delimiter_symbol(value)
        return if value.nil? || value.empty?

        Utility.symbol_object(Utility.string_to_html_entity(value), lang: :omml)
      end

      def delimiter_boundary(character, default_value)
        return delimiter_symbol(default_value) unless character

        delimiter_symbol(character.val)
      end

      def accent_value(value)
        accent = value.first
        unless accent.is_a?(Math::Function::UnaryFunction)
          return Math::Function::Overset.new(accent, value.last, { accent: true })
        end

        accent.attributes = { accent: true }
        accent
      end

      def group_character_above?(properties)
        first_omml_child(properties&.pos)&.val == "top"
      end

      def group_character_above_value(chr, value)
        Math::Function::Overset.new(
          Math::Symbols::Symbol.new(chr || ""),
          value,
        )
      end

      def group_character_below_value(chr, value)
        Math::Function::Underset.new(
          Math::Symbols::Symbol.new(chr || "⏟"),
          value,
        )
      end

      def word_run_font(node)
        bold = enabled_omml_property?(first_omml_child(node.b))
        italic = enabled_omml_property?(first_omml_child(node.i))

        return Utility::FONT_STYLES[:"bold-italic"] if bold && italic
        return Utility::FONT_STYLES[:bold] if bold
        return Utility::FONT_STYLES[:italic] if italic

        nil
      end

      def math_run_font(node)
        font_key = [
          first_omml_child(node.scr)&.val,
          first_omml_child(node.sty)&.val,
        ].compact.join("-")
        return if font_key.empty?

        supported_font = Plurimath::Omml::SUPPORTED_FONTS[font_key.to_sym]
        Utility::FONT_STYLES[supported_font&.to_sym]
      end

      def mapped_children_by_omml_name(node)
        mapped_children = {}

        omml_xml_mappings(node).each do |mapping|
          values = Array(node.public_send(mapping.to))
          next if values.empty?

          mapped_children[mapping.name] ||= []
          # Repeated OMML siblings are common; keep a cursor instead of using
          # Array#shift so consuming children remains linear.
          mapped_children[mapping.name] << { values: values, index: 0 }
        end

        mapped_children
      end

      def consume_ordered_child(mapped_children, element_name)
        child_groups = mapped_children[element_name]
        return nil unless child_groups

        child_groups.each do |children|
          index = children[:index]
          values = children[:values]
          next unless index < values.length

          children[:index] = index + 1
          return values[index]
        end

        nil
      end

      def omml_xml_mappings(node)
        node.class.mappings_for(:xml).mappings(:omml)
      end
    end
  end
end
