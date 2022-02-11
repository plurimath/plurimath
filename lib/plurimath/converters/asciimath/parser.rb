# frozen_string_literal: true

require_relative 'symbols_builder'
require_relative 'sin'
require_relative 'symbol'
require_relative 'variable'
require_relative 'number'
module Plurimath
  module Math
    # Parser Class
    class Parser
      attr_accessor :string

      def initialize(text)
        @string = text
      end

      def parse
        # TODO: Will be implemented soon
      end
    end
  end
end
