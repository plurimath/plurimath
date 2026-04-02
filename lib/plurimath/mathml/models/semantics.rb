# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Semantics < Mml::V4::Semantics
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath
          content = filter_child(wrap_children(children))

          annotations = build_annotations
          Math::Function::Semantics.new(content, annotations.empty? ? nil : annotations)
        end

        private

        def build_annotations
          return [] unless annotation&.any?

          annotation.map do |ann|
            value = ann.respond_to?(:value) ? ann.value : ann.to_s
            { annotation: [Math::Symbols::Symbol.new(value)] }
          end
        end
      end
      Models.register_model(Semantics, id: :semantics)
    end
  end
end
