# frozen_string_literal: true

module Plurimath
  module Math
    # Formula Class
    class Formula
      attr_accessor :text

      def initialize(text)
        @text = text
      end
    end
  end
end
