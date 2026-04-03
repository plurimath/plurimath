# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mfrac < Mml::V4::Mfrac
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath
          opts = extract_options(%i[linethickness bevelled])
          Math::Function::Frac.new(
            filter_child(children[0]),
            filter_child(children[1]),
            opts,
          )
        end
      end
      Models.register_model(Mfrac, id: :mfrac)
    end
  end
end
