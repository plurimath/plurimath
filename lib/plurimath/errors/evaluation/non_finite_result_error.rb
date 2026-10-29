# frozen_string_literal: true

module Plurimath
  module Errors
    module Evaluation
      class NonFiniteResultError < Error
        def initialize
          super("result is not a finite number")
        end
      end
    end
  end
end
