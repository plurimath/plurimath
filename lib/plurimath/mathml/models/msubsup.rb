# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Msubsup < Mml::V4::Msubsup
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath
          base = filter_child(children[0])
          sub = filter_child(children[1])
          sup = filter_child(children[2])

          if base&.is_ternary_function? && !base.any_value_exist?
            base.parameter_one = sub
            base.parameter_two = sup
            base
          elsif base&.is_binary_function? && !base.any_value_exist?
            base.parameter_one = sub
            base.parameter_two = sup
            base
          else
            Math::Function::PowerBase.new(base, sub, sup)
          end
        end
      end
      Models.register_model(Msubsup, id: :msubsup)
    end
  end
end
