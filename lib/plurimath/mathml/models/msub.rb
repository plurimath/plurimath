# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Msub < Mml::V4::Msub
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath
          base = filter_child(children[0])
          sub = filter_child(children[1])

          if base&.is_binary_function? && !base.any_value_exist?
            base.parameter_one = sub
            return base
          end

          Math::Function::Base.new(base, sub)
        end
      end
      Models.register_model(Msub, id: :msub)
    end
  end
end
