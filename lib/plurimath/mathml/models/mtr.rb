# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mtr < Mml::V4::Mtr
        include OrderedChildren

        def to_plurimath
          cells = ordered_children.filter_map do |child|
            child.to_plurimath if child.respond_to?(:to_plurimath)
          end
          Math::Function::Tr.new(cells)
        end
      end
      Models.register_model(Mtr, id: :mtr)
    end
  end
end
