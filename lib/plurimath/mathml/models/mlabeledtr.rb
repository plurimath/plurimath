# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mlabeledtr < Mml::V4::Mlabeledtr
        include OrderedChildren

        def to_plurimath
          cells = ordered_children.filter_map do |child|
            child.to_plurimath if child.respond_to?(:to_plurimath)
          end
          label = id ? Math::Function::Text.new(id) : nil
          Math::Function::Mlabeledtr.new(cells, label)
        end
      end
      Models.register_model(Mlabeledtr, id: :mlabeledtr)
    end
  end
end
