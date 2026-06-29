# frozen_string_literal: true

module Plurimath
  module Errors
    class UnsupportedBase < Plurimath::Error
      def initialize(base, supported_bases)
        @base = base
        @supported = supported_bases.keys.join(", ")
        super(message)
      end

      def message
        "[plurimath] Unsupported base `#{@base}` for number formatting. " \
          "[plurimath] The formatter `:base` option must be one of: #{@supported}."
      end
    end
  end
end
