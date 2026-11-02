# frozen_string_literal: true

module Plurimath
  module Errors
    # A display-only diagnostic; numeric evaluation has its own error contract.
    class UnsupportedSemanticTreeError < Plurimath::Error
      def initialize(construct)
        super("Unsupported semantic tree construct: #{construct}")
      end
    end
  end
end
