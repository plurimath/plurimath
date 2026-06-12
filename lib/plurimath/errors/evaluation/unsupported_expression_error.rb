# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      class UnsupportedExpressionError < Error
        def initialize(message)
          super("unsupported expression: #{message}")
        end
      end
    end
  end
end
