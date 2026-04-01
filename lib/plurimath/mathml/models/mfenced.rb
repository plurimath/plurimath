# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mfenced < Mml::V4::Mfenced
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath.map { |c| filter_child(c) }
          open_p = resolve_paren(self.open || "(")
          close_p = resolve_paren(self.close || ")")
          opts = {}
          opts[:separators] = separators if separators
          Math::Function::Fenced.new(open_p, children, close_p, opts)
        end

        private

        def resolve_paren(value)
          Plurimath::Utility.mathml_unary_classes([value], lang: :mathml)
        end
      end
      Models.register_model(Mfenced, id: :mfenced)
    end
  end
end
