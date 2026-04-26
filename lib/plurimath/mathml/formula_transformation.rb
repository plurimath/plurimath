# frozen_string_literal: true

module Plurimath
  class Mathml
    module FormulaTransformation
      private

      # Use each_mixed_content to get children in document order.
      def ordered_children(node)
        children = []
        node.each_mixed_content { |child| children << child }
        children
      end

      def text_value(value)
        return if value.nil?
        return value if value.is_a?(String)

        Array(value).join
      end

      def mathml_symbol(value)
        Plurimath::Utility.mathml_unary_classes([value], lang: :mathml)
      end

      # Alignment markers affect MathML layout only; the old parser dropped them
      # before building the Plurimath AST.
      def content_children(node)
        ordered_children(node).reject do |child|
          child.is_a?(Mml::V4::Malignmark) || child.is_a?(Mml::V4::Maligngroup)
        end
      end

      def default_fenced_open(fenced)
        "(" unless fenced.close
      end

      def default_fenced_close(fenced)
        ")" unless fenced.open
      end

      def resolve_paren(value)
        return nil unless value

        mathml_symbol(value)
      end

      def extract_ms_text(node)
        return (node.empty? ? nil : node) if node.is_a?(String)

        if ms_token_element?(node)
          return Array(node.value).join
        end

        if node.respond_to?(:each_mixed_content)
          return ordered_children(node).filter_map do |child|
            extract_ms_text(child)
          end.join(" ")
        end

        Array(node.value).join if node.respond_to?(:value)
      end

      def ms_token_element?(node)
        node.is_a?(Mml::V4::Mi) ||
          node.is_a?(Mml::V4::Mn) ||
          node.is_a?(Mml::V4::Mo) ||
          node.is_a?(Mml::V4::Ms) ||
          node.is_a?(Mml::V4::Mtext)
      end

      def normalize_phantom_child(child)
        return child unless child.respond_to?(:value=) && child.respond_to?(:value)
        return child if child.instance_of?(Math::Symbols::Symbol)
        return child unless child.value.is_a?(String)
        return child unless child.value.match?(/\A[[:space:]]|[[:space:]]\z/)

        child.value = nil
        child
      end

      def boolean_to_displaystyle(value)
        case value
        when "true", true then true
        when "false", false then false
        else true
        end
      end

      def truthy_mathml_bool?(value)
        [true, "true"].include?(value)
      end

      def filter_child(value)
        return nil if value.nil?
        return value unless value.is_a?(Math::Formula)
        return value if value.value.nil? || value.value.empty?

        value.value.length == 1 ? value.value.first : value
      end

      def wrap_children(children)
        case children.length
        when 0 then nil
        when 1 then children.first
        else Math::Formula.new(children)
        end
      end

      def nary_check(children)
        return children unless children.length == 2

        first = children.first
        second = children.last

        if first.is_a?(Math::Function::PowerBase) && first.parameter_one&.is_nary_symbol?
          [Math::Function::Nary.new(
            first.parameter_one,
            first.parameter_two,
            first.parameter_three,
            second,
          )]
        elsif first.is_a?(Math::Function::Overset) && first.parameter_two&.is_nary_symbol?
          [Math::Function::Nary.new(
            first.parameter_two,
            nil,
            first.parameter_one,
            second,
            { type: "undOvr" },
          )]
        elsif first.is_a?(Math::Function::Power) && first.parameter_one&.is_nary_symbol?
          [Math::Function::Nary.new(
            first.parameter_one,
            nil,
            first.parameter_two,
            second,
            { type: "subSup" },
          )]
        else
          children
        end
      end

      def fill_ternary_third_values(values)
        return unless values.is_a?(Array) && values.length > 1

        first = values.first
        return if preserve_separate_nary_body?(first, values[1])

        if first.is_a?(Math::Function::Nary)
          first.parameter_four ||= values.delete_at(1)
        elsif first.respond_to?(:is_nary_function?) && first.is_nary_function? && !first.all_values_exist?
          if first.respond_to?(:new_nary_function) && !first.any_value_exist?
            values[0] = first.new_nary_function(values.delete_at(1))
          elsif first.any_value_exist?
            first.parameter_three = values.delete_at(1)
          end
        elsif value_is_ternary_or_nary?(values)
          first.parameter_three = values.delete_at(1)
        end
      end

      def unwrap_single(value)
        return nil if value.nil? || (value.is_a?(Array) && value.empty?)
        return value unless value.is_a?(Array)

        value.length == 1 ? value.first : Math::Formula.new(value)
      end

      def preserve_separate_nary_body?(first, second)
        return false unless first.respond_to?(:is_nary_function?) && first.is_nary_function?

        normalized_second = filter_child(second)

        normalized_second.is_a?(Math::Function::Base) ||
          normalized_second.is_a?(Math::Function::PowerBase)
      end

      def preserve_explicit_nary_body!(values)
        return unless values.is_a?(Array) && values.any?

        first = values.first
        return unless first.is_a?(Math::Function::Nary)
        return unless first.options&.[](:type) == "undOvr"

        body = filter_child(first.parameter_four)
        return unless body.is_a?(Math::Function::Base) ||
          body.is_a?(Math::Function::PowerBase)

        replacement =
          if first.parameter_three.nil?
            Math::Function::Underset.new(first.parameter_two,
                                         first.parameter_one)
          else
            Math::Function::Underover.new(
              first.parameter_one,
              first.parameter_two,
              first.parameter_three,
            )
          end

        values[0] = replacement
        values.insert(1, body)
      end

      def convert_multiscript_child(child)
        return Math::Function::None.new if child.is_a?(Mml::V4::None) || child.is_a?(Mml::V3::None)
        return Math::Function::None.new if child.respond_to?(:value) && Array(child.value).join.empty?

        mml_to_plurimath(child) || Math::Function::None.new
      end

      def convert_multiscript_children(children)
        Array(children).map { |child| convert_multiscript_child(child) }
      end

      def multiscript_post_element_count(element_order, prescript_index)
        post_names = element_order[0...prescript_index]
          .select { |element| element.node_type == :element }
          .map(&:name)
        post_names.size - 1
      end

      def split_multiscript_children(children, post_element_count)
        [
          convert_multiscript_children(children[1..post_element_count]),
          convert_multiscript_children(children[(post_element_count + 1)..]),
        ]
      end

      def split_script_pairs(children, compact: false)
        pairs = children.each_slice(2).to_a
        subscripts = pairs.map { |pair| pair[0] if pair[0] }
        superscripts = pairs.map { |pair| pair[1] if pair[1] }

        if compact
          [subscripts.compact, superscripts.compact]
        else
          [subscripts, superscripts]
        end
      end

      def attach_postscripts(base, subscripts, superscripts)
        normalized_base = filter_child(base)
        return normalized_base unless subscripts.any? || superscripts.any?

        Math::Function::PowerBase.new(
          normalized_base,
          unwrap_single(subscripts),
          unwrap_single(superscripts),
        )
      end

      def build_annotation_entries(entries, tag_name)
        return [] unless entries&.any?

        entries.map do |annotation|
          value = annotation.respond_to?(:value) ? annotation.value : annotation.to_s
          { tag_name => [Math::Symbols::Symbol.new(value)] }
        end
      end

      # Heuristic: combine function name with following opening parenthesis.
      def combine_function_with_parens(values)
        return values if values.size < 2

        result = []
        i = 0
        while i < values.size
          current = values[i]
          if i + 1 < values.size && can_combine_with_paren?(current)
            next_elem = values[i + 1]
            if opening_paren?(next_elem)
              paren = if next_elem.respond_to?(:paren?) && next_elem.paren?
                        next_elem
                      else
                        Math::Symbols::Paren::Lround.new
                      end
              result << current.class.new(paren)
              i += 2
              next
            end
          end
          result << current
          i += 1
        end
        result
      end

      def opening_paren?(obj)
        return true if obj.is_a?(Math::Symbols::Symbol) && obj.value == "("
        return true if obj.class_name == "lround"
        return true if obj.respond_to?(:paren?) && obj.paren? && obj.respond_to?(:to_asciimath) && obj.to_asciimath(options: {}) == "("

        false
      end

      def can_combine_with_paren?(obj)
        return false unless obj.respond_to?(:class)

        obj.class < Math::Function::UnaryFunction
      end

      def apply_font_style(element, result)
        return result unless element.respond_to?(:mathvariant)

        variant = element.mathvariant
        return result if variant.nil? || variant.empty?

        font_class = Plurimath::Utility::FONT_STYLES[variant.to_sym]
        return result unless font_class

        font_class.new(result, variant)
      end

      def filter_values(value, array_to_instance: false, replacing_order: true)
        return value unless value.is_a?(Array)
        return array_to_instance ? nil : value if value.empty?

        if is_a?(Math::Formula) && value.length == 1 && value.first.is_mstyle?
          @displaystyle = value.first.displaystyle
        end

        if value.length == 1 && value.all?(Math::Formula)
          if array_to_instance
            filter_values(value.first.value, array_to_instance: true)
          else
            value.first.value
          end
        elsif value.is_a?(Array) && value.any?(Math::Formula::Mrow)
          value.each_with_index do |element, index|
            next unless element.is_a?(Math::Formula::Mrow)

            value[index] = filter_values(
              Array(element),
              array_to_instance: true,
              replacing_order: replacing_order,
            )
          end
          value
        elsif value_is_ternary_or_nary?(value)
          value.first.parameter_three = value.delete_at(1)
          filter_values(
            Array(value),
            array_to_instance: array_to_instance,
            replacing_order: replacing_order,
          )
        elsif ternary_naryable?(value)
          [
            Math::Function::Nary.new(
              value.first.parameter_one,
              value.first.parameter_two,
              value.first.parameter_three,
              value.last,
            ),
          ]
        elsif overset_naryable?(value)
          [
            Math::Function::Nary.new(
              value.first.parameter_two,
              nil,
              value.first.parameter_one,
              value.last,
              { type: "undOvr" },
            ),
          ]
        elsif power_naryable?(value)
          [
            Math::Function::Nary.new(
              value.first.parameter_one,
              nil,
              value.first.parameter_two,
              value.last,
              { type: "subSup" },
            ),
          ]
        elsif array_to_instance && replacing_order
          value.length > 1 ? Math::Formula.new(value) : value.first
        else
          value
        end
      end

      def validate_symbols(value)
        case value
        when Array
          array_validations(value)
        when Math::Symbols::Symbol
          return value if value.value.nil?

          instance = mathml_symbol_to_class(value.value)
          if value&.options&.any? && instance.is_a?(Math::Symbols::Symbol)
            instance.options = value.options
          end
          instance
        when String
          mathml_symbol_to_class(value)
        end
      end

      def array_validations(value)
        value.each_with_index do |val, index|
          next unless val.is_a?(Math::Symbols::Symbol)

          value[index] = mathml_symbol_to_class(val.value) unless val.value.nil?
        end
        value
      end

      def mathml_symbol_to_class(symbol)
        Plurimath::Utility.mathml_unary_classes(
          Array(symbol),
          lang: :mathml,
        )
      end

      def value_is_ternary_or_nary?(value)
        return false if value.any?(String)

        value.length >= 2 &&
          value.first.is_ternary_function? &&
          value.first.parameter_three.nil? &&
          (!value.first.parameter_one.nil? || !value.first.parameter_two.nil?)
      end

      def ternary_naryable?(value)
        value.length == 2 &&
          value.first.is_a?(Math::Function::PowerBase) &&
          value.first.parameter_one.is_nary_symbol?
      end

      def overset_naryable?(value)
        value.length == 2 &&
          value.first.is_a?(Math::Function::Overset) &&
          value.first.parameter_two.is_nary_symbol?
      end

      def power_naryable?(value)
        value.length == 2 &&
          value.first.is_a?(Math::Function::Power) &&
          value.first.parameter_one.is_nary_symbol?
      end
    end
  end
end
