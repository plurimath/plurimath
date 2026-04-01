# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mfraction < Mml::V4::Mfraction
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
      Models.register_model(Mfraction, id: :mfraction)
    end
  end
end
