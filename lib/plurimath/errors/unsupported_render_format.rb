# frozen_string_literal: true

module Plurimath
  module Errors
    class UnsupportedRenderFormat < Plurimath::Error
      def initialize(format, supported)
        @format = format
        @supported = supported.map(&:inspect).join(", ")
        super(message)
      end

      def message
        "[plurimath] Unsupported render format #{@format.inspect}. " \
          "Supported formats are: #{@supported}."
      end
    end
  end
end
