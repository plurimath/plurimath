# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Munderover < Mml::V4::Munderover
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath
          base = filter_child(children[0])
          under = filter_child(children[1])
          over = filter_child(children[2])

          if base&.is_ternary_function? && !base.any_value_exist?
            base.parameter_one = under
            base.parameter_two = over
            base
          elsif base&.is_nary_symbol?
            Math::Function::Nary.new(base, under, over, nil, { type: "undOvr" })
          else
            Math::Function::Underover.new(base, under, over)
          end
        end
      end
      Models.register_model(Munderover, id: :munderover)
    end
  end
end
