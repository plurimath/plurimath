# frozen_string_literal: true

require_relative "constants"
require_relative "transform"
module Plurimath
  class Omml
    class Parser
      attr_accessor :text

      def initialize(text)
        @text = CGI.unescape(text)
      end

      def parse
        nodes = Ox.load(text, mode: :hash, strip_namespace: true)
        Math::Formula.new(
          Transform.new.apply(nodes),
        )
      end
    end
  end
end
