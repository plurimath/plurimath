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

      def mapped_children_by_omml_name(node)
        mapped_children = {}

        omml_xml_mappings(node).each do |mapping|
          values = Array(node.public_send(mapping.to))
          next if values.empty?

          mapped_children[mapping.name] ||= []
          mapped_children[mapping.name] << values.dup
        end

        mapped_children
      end

      def consume_ordered_child(mapped_children, element_name)
        child_groups = mapped_children[element_name]
        return nil unless child_groups

        child_groups.each do |children|
          return children.shift if children.any?
        end

        nil
      end

      def omml_xml_mappings(node)
        node.class.mappings_for(:xml).mappings(:omml)
      end
    end
  end
end
