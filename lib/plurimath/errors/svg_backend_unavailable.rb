# frozen_string_literal: true

module Plurimath
  module Errors
    class SvgBackendUnavailable < Plurimath::Error
      def initialize(reason = nil)
        @reason = reason
        super(message)
      end

      def message
        text =
          "[plurimath] SVG output needs a registered SVG backend. Set one with " \
          "Plurimath::Math::SvgRenderer.backend = <object responding to " \
          "render_svg(mathml, **options)>."
        return text unless @reason

        "#{text} Reason: #{@reason}"
      end
    end
  end
end
