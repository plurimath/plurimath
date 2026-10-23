# frozen_string_literal: true

module Plurimath
  module Errors
    # Raised when an uncertainty (Math::Function::Uncertainty) is built from
    # fields that do not form a valid reported result.
    class InvalidUncertainty < Plurimath::Error
      def initialize(detail)
        @detail = detail
        super(message)
      end

      def message
        "[plurimath] Invalid uncertainty: #{@detail}."
      end
    end
  end
end
