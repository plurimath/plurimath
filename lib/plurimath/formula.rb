# frozen_string_literal: true

module Plurimath
  # Formula Class
  class Formula
    attr_accessor :text

    def initialize(str)
      @text = str
    end
  end
end
