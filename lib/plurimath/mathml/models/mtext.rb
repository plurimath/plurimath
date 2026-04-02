# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mtext < Mml::V4::Mtext
        include OrderedChildren

        def to_plurimath
          text_obj = Math::Function::Text.new
          text_obj.value = Array(value).join
          text_obj
        end
      end
      Models.register_model(Mtext, id: :mtext)
    end
  end
end
