# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mroot < Mml::V4::Mroot
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath
          # MathML mroot: first child is radicand, second is degree
          # Plurimath Root: parameter_one is degree, parameter_two is radicand
          Math::Function::Root.new(
            filter_child(children[1]),
            filter_child(children[0]),
          )
        end
      end
      Models.register_model(Mroot, id: :mroot)
    end
  end
end
