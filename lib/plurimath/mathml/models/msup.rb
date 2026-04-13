# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Msup < Mml::V4::Msup
        include OrderedChildren

        def to_plurimath
          children = structural_children_to_plurimath
          base = filter_child(children[0])
          sup = filter_child(children[1])

          if base&.is_binary_function? && !base.any_value_exist?
            base.parameter_one = sup
            return base
          end

          Math::Function::Power.new(base, sup)
        end
      end
      Models.register_model(Msup, id: :msup)
    end
  end
end
