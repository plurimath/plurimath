# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Msgroup < Mml::V4::Msgroup
        include OrderedChildren

        def to_plurimath
          children = ordered_children.filter_map do |child|
            if child.respond_to?(:to_plurimath)
              child.to_plurimath
            elsif child.is_a?(String)
              Math::Function::Text.new(child)
            end
          end
          Math::Function::Msgroup.new(children)
        end
      end
      Models.register_model(Msgroup, id: :msgroup)
    end
  end
end
