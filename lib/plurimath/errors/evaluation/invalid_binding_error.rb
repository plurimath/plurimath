# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      class InvalidBindingError < Error
        def initialize(name, value)
          super("wrong value for variable `#{name}` " \
                "(given #{value.class}, expected a real number)")
        end
      end
    end
  end
end
