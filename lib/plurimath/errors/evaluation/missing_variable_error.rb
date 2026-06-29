# frozen_string_literal: true

module Plurimath
  module Errors
    module Evaluation
      class MissingVariableError < Error
        def initialize(name)
          super("missing value for variable `#{name}`")
        end
      end
    end
  end
end
