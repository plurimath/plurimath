# frozen_string_literal: true

module Plurimath
  module Errors
    class RenderingFailed < Plurimath::Error
      def initialize(format, cause)
        @format = format
        @failure = cause
        super(message)
      end

      def message
        "[plurimath] Failed to render MathML to #{@format}: #{@failure.message}."
      end
    end
  end
end
