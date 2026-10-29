# frozen_string_literal: true

module Plurimath
  module Errors
    module Evaluation
      class DivisionByZeroError < Error
        def initialize
          super("divided by 0")
        end
      end
    end
  end
end
