# frozen_string_literal: true

module Plurimath
  module Math
    # Backend registry for image rendering: a MathML document renders to an
    # image through the selected engine. The default engine is `:lasem`
    # (via the optional `lasem` gem); `:logifos` renders through the
    # optional `logifos` gem and its native library.
    #
    # This is NOT part of the public API: reach rendering via Plurimath::Math.render
    # or Plurimath::Math::Formula#render. Renderer is the single place any
    # rendering gem (native, Opal-incompatible) is required, so the rest of
    # the library stays decoupled from them. Opal excludes the guarded
    # native requires when compiling these autoloaded backends, and every
    # backend's available? is always false under Opal.
    #
    # Not thread-safe: the lasem native render keeps static parser state and
    # the backends record load diagnostics in module state, so callers
    # should not render concurrently.
    module Renderer
      autoload :Lasem, "#{__dir__}/renderer/lasem"
      autoload :Logifos, "#{__dir__}/renderer/logifos"

      # Output image formats accepted across all engines.
      OUTPUT_FORMATS = %i[svg png pdf ps].freeze

      # Keyword options forwarded to Formula#to_mathml (the serialization step).
      MATHML_OPTIONS = %i[
        intent formatter unitsml split_on_linebreak display_style
        unary_function_spacing
      ].freeze

      # Keyword options accepted by the lasem backend (geometry forwarded to
      # Lasem.render; nil values are dropped so lasem applies its defaults).
      LASEM_OPTIONS = %i[ppi zoom width height offset_x offset_y].freeze

      # Engines by name, in registration order.
      ENGINES = {
        lasem: Renderer::Lasem,
        logifos: Renderer::Logifos,
      }.freeze

      module_function

      # Render a MathML document to a binary image string through the
      # selected engine. Raises a Plurimath::Errors rendering error
      # (UnsupportedRenderFormat, UnsupportedRenderEngine,
      # RenderingUnavailable, or RenderingFailed) on any problem.
      def render(mathml, format:, engine: :lasem, **opts)
        format = normalize_format(format)
        backend = normalize_engine(engine)
        ensure_supported!(backend, format, engine)
        ensure_available!(backend, engine)
        backend.render(mathml, format: format, **opts)
      end

      # True when the default engine (lasem) renders here. Never raises.
      def available?
        available_engines.include?(:lasem)
      end

      # The engine names that render on this runtime. Never raises.
      def available_engines
        return [] if RUBY_ENGINE == "opal"

        ENGINES.filter_map { |name, backend| name if backend.available? }
      end

      def normalize_format(format)
        symbol = format.to_s.downcase.to_sym
        return symbol if OUTPUT_FORMATS.include?(symbol)

        raise Errors::UnsupportedRenderFormat.new(format, OUTPUT_FORMATS)
      end

      def normalize_engine(engine)
        name = engine.to_s.downcase.to_sym
        return ENGINES.fetch(name) if ENGINES.key?(name)

        raise Errors::UnsupportedRenderEngine.new(engine, ENGINES.keys)
      end

      def ensure_supported!(backend, format, _engine)
        return if backend.formats.include?(format)

        raise Errors::UnsupportedRenderFormat.new(format, backend.formats)
      end

      def ensure_available!(backend, engine)
        return if backend.available?

        raise Errors::RenderingUnavailable.new(backend.load_error, engine: engine)
      end
    end
  end
end
