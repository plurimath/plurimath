# frozen_string_literal: true

module Plurimath
  module Errors
    module Evaluation
      class UnsupportedExpressionError < Error
        def initialize(message)
          super("unsupported expression: #{message}")
        end
      end
    end
  end
end
