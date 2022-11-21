# frozen_string_literal: true

module Plurimath
  module Math
    class Unicode < Symbol

      def to_asciimath
        decode
      end

      def to_latex
        decode
      end

      def decode
        HTMLEntities.new.decode(value)
      end
    end
  end
end
