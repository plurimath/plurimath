# frozen_string_literal: true

module Plurimath
  module Formatter
    class UnsupportedBase < Plurimath::Error
      def initialize(base, supported_bases)
        @base = base
        @supported = supported_bases.keys.map do |key|
          key.to_s.inspect
        end.join(", ")
      end

      def to_s
        <<~MESSAGE
          [plurimath] Unsupported base `#{@base}` for number formatting.
          [plurimath] The formatter `:base` option must be one of: #{@supported}.
        MESSAGE
      end
    end
  end
end
