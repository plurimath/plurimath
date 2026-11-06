# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Semantics < BinaryFunction
        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "A presentation expression paired with its semantic annotations."
        REFERENCE = "https://developer.mozilla.org/en-US/docs/Web/MathML/Reference/Element/semantics"
        EXAMPLE = -> { new(sym("x"), [{ "annotation-xml": [sym("x")] }]) }
        CATALOG_FORMAT_LIMITATIONS = {
          asciimath: {
            status: :limited,
            notes: ["Semantic annotations are omitted; only the presentation expression is emitted."],
          },
          latexmath: {
            status: :limited,
            notes: ["Semantic annotations are omitted; only the presentation expression is emitted."],
          },
          omml: {
            status: :limited,
            notes: ["Semantic annotations are omitted; only the presentation expression is emitted."],
          },
        }.freeze
        # --- end catalog documentation ---

        # One annotation of parameter_two, which holds them as
        # { tag => [nodes] } hashes. It exists only so that lutaml-model can
        # map the annotations; writers keep reading the hashes.
        class Annotation < Core
          node_fields :content, collections: %i[content], symbols: %i[tag]

          def ==(other)
            other.is_a?(Annotation) && other.tag == tag && other.content == content
          end
        end

        # parameter_two holds annotation hashes rather than nodes, so its
        # list view goes through Annotation nodes.
        def __parameter_two_nodes
          return unless parameter_two.is_a?(::Array) && !parameter_two.empty? &&
            parameter_two.all?(::Hash)

          parameter_two.flat_map do |hash|
            hash.map do |tag, content|
              Annotation.new.tap do |annotation|
                annotation.tag = tag
                annotation.content = content
              end
            end
          end
        end

        def __parameter_two_nodes=(value)
          return unless value.is_a?(::Array) && !value.empty?

          @parameter_two = value.map do |item|
            item.is_a?(Annotation) ? { item.tag => item.content } : item
          end
        end

        FUNCTION = {
          name: "semantics",
          first_value: "first argument",
          second_value: "second argument",
        }.freeze

        def to_mathml_without_math_tag(intent, options:)
          first_value = parameter_one&.to_mathml_without_math_tag(intent,
                                                                  options: options)
          XmlHelper.update_nodes(
            XmlHelper.ox_element("semantics"),
            other_tags(parameter_two, intent, options: options).insert(0,
                                                                       first_value),
          )
        end

        def to_latex(options:)
          parameter_one&.to_latex(options: options)
        end

        def to_asciimath(options:)
          parameter_one&.to_asciimath(options: options)
        end

        def to_omml_without_math_tag(display_style, options:)
          Array(parameter_one.insert_t_tag(display_style, options: options))
        end

        def line_breaking(obj)
          parameter_one&.line_breaking(obj)
          if obj.value_exist?
            semantics = self.class.new(Utility.filter_values(obj.value),
                                       parameter_two)
            self.parameter_two = nil
            obj.update(semantics)
          end
        end

        protected

        def other_tags(array, intent, options:)
          contented = []
          array&.each do |hash|
            hash.each do |tag, content|
              tag_element = XmlHelper.ox_element(tag&.to_s)
              contented << XmlHelper.update_nodes(
                tag_element,
                content&.map { |object|
                  object&.to_mathml_without_math_tag(intent, options: options)
                },
              )
            end
          end
          contented
        end
      end
    end
  end
end
