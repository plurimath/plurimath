# frozen_string_literal: true

module Plurimath
  class Omml
    class UnsupportedNodeError < StandardError
      def initialize(node)
        @node = node
        super(message)
      end

      def message
        "[plurimath] Unsupported OMML typed node: #{@node.class}"
      end
    end
  end
end
