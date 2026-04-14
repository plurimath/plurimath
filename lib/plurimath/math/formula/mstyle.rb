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

        def omml_content(display_style, options:)
          # Use Mstyle's own @displaystyle, not the passed-in display_style
          effective_display = @displaystyle.nil? ? display_style : @displaystyle
          value&.map { |val| val.insert_t_tag(effective_display, options: options) }
        end
      end
    end
  end
end
