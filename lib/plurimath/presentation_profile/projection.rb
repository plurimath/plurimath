# frozen_string_literal: true

module Plurimath
  class PresentationProfile
    # A temporary display view. Copy node fields without changing the stored
    # model, its evaluation semantics, or its serialization schema.
    class Projection
      class Identifier < Math::Function::FontStyle
        def to_mathml_without_math_tag(intent, options:)
          token = parameter_one.to_mathml_without_math_tag(intent, options: options)
          token["mathvariant"] = parameter_two
          token
        end

        def to_omml_without_math_tag(display_style, options:)
          font_styles(display_style, options: options,
                                   sty: parameter_two == "normal" ? "p" : "i")
        end
      end
      private_constant :Identifier

      def initialize(profile, context)
        @profile = profile
        @context = context
      end

      def call(node, function_call: false)
        return sequence(node) if node.is_a?(Array)
        return node unless node.is_a?(Math::Core)
        # An explicit font (including MathML mathvariant) outranks assumptions
        # and the caller's semantic roles. displaystyle is not a font.
        if node.is_a?(Math::Function::FontStyle) &&
            node.mathml_style_attributes.key?(:mathvariant)
          return node
        end

        if node.is_a?(Math::Symbols::Symbol)
          return identifier(node, function_call)
        end

        copy = node.dup
        node.variables.each { |field| copy.set(field, call(node.get(field))) }
        copy
      end

      private

      def sequence(nodes)
        nodes.each_with_index.map do |node, index|
          call(node, function_call: round_fenced?(nodes[index + 1]))
        end
      end

      def round_fenced?(node)
        node.is_a?(Math::Function::Fenced) &&
          node.parameter_one&.to_asciimath(options: {}) == "(" &&
          node.parameter_three&.to_asciimath(options: {}) == ")"
      end

      def identifier(node, function_call)
        token = node.to_mathml_without_math_tag(false, options: {})
        return node unless token.respond_to?(:name) && token.name == "mi"

        name = Utility.html_entity_to_unicode(token.nodes.join)
        role = @profile.role(name, @context, function_call: function_call)
        variant = role ? (role == :variable ? "italic" : "normal") : @profile.fallback_variant(name)
        return node unless variant

        Identifier.new(node, variant)
      end
    end
  end
end
