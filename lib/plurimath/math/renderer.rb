# frozen_string_literal: true

module Plurimath
  module Math
    # Internal bridge to the optional `lasem` gem, which renders MathML to
    # SVG/PNG/PDF/PostScript through a native extension.
    #
    # This is NOT part of the public API: reach rendering via Plurimath::Math.render
    # or Plurimath::Math::Formula#render. Renderer is the single place `lasem`
    # (native, Opal-incompatible) is required, so the rest of the library stays
    # decoupled from it. The file is autoloaded and only referenced as a constant,
    # so it is never pulled into the Opal/plurimath-js bundle.
    #
    # Not thread-safe: the underlying Lasem native render keeps static parser
    # state and the +@load_error+ diagnostic is shared module state, so callers
    # should not render concurrently.
    module Renderer
      # Output image formats accepted by lasem.
      OUTPUT_FORMATS = %i[svg png pdf ps].freeze

      # Keyword options forwarded to Formula#to_mathml (the serialization step).
      MATHML_OPTIONS = %i[
        intent formatter unitsml split_on_linebreak display_style
        unary_function_spacing
      ].freeze

      # Geometry options forwarded straight to Lasem.render. The names match
      # lasem's own kwargs; nil values are dropped so lasem applies its defaults.
      LASEM_OPTIONS = %i[ppi zoom width height offset_x offset_y].freeze

      module_function

      # Render a MathML document to a binary image string. Raises a
      # Plurimath::Errors rendering error (UnsupportedRenderFormat,
      # RenderingUnavailable, or RenderingFailed) on any problem.
      def render(mathml, format:, **opts)
        format = normalize_format(format)
        ensure_available!
        render_with_backend(mathml, format, opts)
      end

      # Only the backend call is wrapped here, so the UnsupportedRenderFormat /
      # RenderingUnavailable errors raised above are not re-wrapped.
      def render_with_backend(mathml, format, opts)
        Lasem.render(
          mathml,
          input: :mathml,
          output: format,
          **opts.slice(*LASEM_OPTIONS).compact,
        )
      rescue StandardError => e
        # Catches Lasem::RenderError/DependencyError AND Lasem::OptionError, which
        # is an ArgumentError living OUTSIDE Lasem::Error (lasem-ruby errmodel-1),
        # so we deliberately rescue StandardError rather than Lasem::Error.
        raise Errors::RenderingFailed.new(format, e)
      end
      private_class_method :render_with_backend

      # True only when this is a non-Opal runtime, the `lasem` gem loads, and its
      # native extension reports itself available. Never raises.
      def available?
        return false if RUBY_ENGINE == "opal"

        @load_error = nil
        load_lasem && Lasem.native_available?
      rescue StandardError => e
        @load_error = e
        false
      end

      def normalize_format(format)
        symbol = format.to_s.downcase.to_sym
        return symbol if OUTPUT_FORMATS.include?(symbol)

        raise Errors::UnsupportedRenderFormat.new(format, OUTPUT_FORMATS)
      end

      def ensure_available!
        return if available?

        raise Errors::RenderingUnavailable.new(@load_error)
      end

      # Lazily require the optional gem. Only ever reached on the non-Opal path.
      # Returns true on success, false on LoadError (recorded for diagnostics).
      def load_lasem
        return true if defined?(Lasem)

        require "lasem"
        true
      rescue LoadError => e
        @load_error = e
        false
      end
    end
  end
end
