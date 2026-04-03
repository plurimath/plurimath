# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mfenced < Mml::V4::Mfenced
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath.map { |c| filter_child(c) }
          open_val = @open || default_open
          close_val = @close || default_close
          Math::Function::Fenced.new(
            resolve_paren(open_val),
            children,
            resolve_paren(close_val),
            { separators: separators }.compact,
          )
        end

        private

        def default_open
          "(" unless @close
        end

        def default_close
          ")" unless @open
        end

        def resolve_paren(value)
          return unless value

          Plurimath::Utility.mathml_unary_classes([value], lang: :mathml)
        end
      end
      Models.register_model(Mfenced, id: :mfenced)
    end
  end
end
