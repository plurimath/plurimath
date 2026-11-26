# frozen_string_literal: true

module Plurimath
  module Math
    # Backend-neutral seam for SVG output (a render-mode option). Plurimath
    # serializes a formula to MathML and hands it to a registered backend; it
    # ships no renderer and depends on none.
    #
    # A backend is any object responding to
    # <tt>render_svg(mathml, **options)</tt> and returning an SVG String.
    # Reach this through Formula#to_svg.
    module SvgRenderer
      # Keyword options forwarded to Formula#to_mathml.
      MATHML_OPTIONS = %i[
        intent formatter unitsml split_on_linebreak display_style
        unary_function_spacing
      ].freeze

      class << self
        attr_reader :backend

        def backend=(backend)
          if !backend.nil? && !backend.respond_to?(:render_svg)
            raise ArgumentError, "SVG backend must respond to #render_svg"
          end

          @backend = backend
        end

        def available?
          !backend.nil?
        end

        # Render +mathml+ with the registered backend. Remaining options are
        # passed to the backend unchanged.
        def render(mathml, **opts)
          raise Errors::SvgBackendUnavailable if backend.nil?

          svg = backend.render_svg(mathml, **opts)
          return svg if svg.is_a?(String)

          raise Errors::RenderingFailed.new(
            :svg, TypeError.new("SVG backend returned #{svg.class}, expected String")
          )
        rescue Errors::SvgBackendUnavailable, Errors::RenderingFailed
          raise
        rescue StandardError => e
          raise Errors::RenderingFailed.new(:svg, e)
        end
      end
    end
  end
end
