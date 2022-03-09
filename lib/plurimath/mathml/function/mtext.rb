# frozen_string_literal: true

module Plurimath
  class Mathml
    module Function
      class Mtext
        attr_accessor :text

        def initialize(text)
          @text = text
        end
      end
    end
  end
end
