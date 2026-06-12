# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      class NonFiniteResultError < Error
        def initialize
          super("result is not a finite number")
        end
      end
    end
  end
end
