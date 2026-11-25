# frozen_string_literal: true

module Plurimath
  class PresentationProfile
    # Changes exact output tokens once, after layout and identifier semantics.
    class Tokens
      def initialize(symbols, spacing)
        @symbols = normalize_symbols(symbols)
        @spacing = normalize_spacing(spacing)
        freeze
      end

      def apply(node, format)
        return node if @symbols.empty? && @spacing.empty?
        return node unless node.respond_to?(:nodes)

        token = format == :mathml ? %w[mi mo].include?(node.name) : node.name == "m:t"
        if token && node.nodes.all? { |child| child.is_a?(String) }
          name = Utility.html_entity_to_unicode(node.nodes.join)
          Plurimath.xml_engine.replace_nodes(node, @symbols[name]) if @symbols.key?(name)
          if format == :mathml && node.name == "mo"
            @spacing.fetch(name, {}).each do |attribute, width|
              node[attribute] = width unless node[attribute]
            end
          end
        elsif format == :omml && node.name == "m:chr"
          name = Utility.html_entity_to_unicode(node["m:val"] || node["val"])
          if @symbols.key?(name)
            node.remove_attr("m:val")
            node.remove_attr("val")
            node.set_attr("m:val" => @symbols[name])
          end
        end
        node.nodes.each { |child| apply(child, format) }
        node
      end

      private

      def normalize_symbols(symbols)
        raise ArgumentError, "symbols must be a Hash" unless symbols.is_a?(Hash)

        symbols.each_with_object({}) do |(name, replacement), result|
          unless replacement.is_a?(String) && !replacement.empty? &&
              !replacement.match?(/[&\x00-\x1f\x7f]/)
            raise ArgumentError, "symbols requires nonempty token text without ampersands or control characters"
          end
          result[name.to_s.dup.freeze] = replacement.dup.freeze
        end.freeze
      end

      def normalize_spacing(spacing)
        raise ArgumentError, "operator_spacing must be a Hash" unless spacing.is_a?(Hash)

        spacing.each_with_object({}) do |(name, widths), result|
          unless widths.is_a?(Hash) && (widths.keys - %i[lspace rspace]).empty? &&
              widths.values.all? { |width| width.is_a?(String) && width.match?(/\A(?:\d+(?:\.\d+)?|\.\d+)em\z/) }
            raise ArgumentError, "operator_spacing requires lspace/rspace lengths in em"
          end
          result[name.to_s.dup.freeze] = widths.transform_values { |width| width.dup.freeze }.freeze
        end.freeze
      end
    end
  end
end
