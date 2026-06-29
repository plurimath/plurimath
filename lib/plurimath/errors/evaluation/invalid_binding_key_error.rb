# frozen_string_literal: true

module Plurimath
  module Errors
    module Evaluation
      class InvalidBindingKeyError < Error
        def initialize(key)
          super("wrong type for binding key " \
                "(given #{key.class}, expected String or Symbol)")
        end
      end
    end
  end
end
