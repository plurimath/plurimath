# frozen_string_literal: true

module Plurimath
  module Math
    class Formula
      class Mstyle < Formula
        def displaystyle=(value)
          @displaystyle = boolean_display_style(value)
        end

        def is_mstyle?
          true
        end
      end
    end
  end
end
