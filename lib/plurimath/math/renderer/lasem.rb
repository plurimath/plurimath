# frozen_string_literal: true

module Plurimath
  module Math
    module Renderer
      # The lasem backend: MathML to SVG/PNG/PDF/PostScript through the
      # optional `lasem` gem and its native extension. Registered in
      # Renderer::ENGINES; see the registry for the shared contract.
      module Lasem
        FORMATS = %i[svg png pdf ps].freeze

        module_function

        # The output formats this engine accepts.
        def formats
          FORMATS
        end

        # Render a MathML document to a binary image string. Engine errors
        # wrap as RenderingFailed; the format/engine/availability errors are
        # the registry's.
        def render(mathml, format:, **opts)
          ::Lasem.render(
            mathml,
            input: :mathml,
            output: format,
            **opts.slice(*Renderer::LASEM_OPTIONS).compact,
          )
        rescue StandardError => e
          # Catches Lasem::RenderError/DependencyError AND Lasem::OptionError, which
          # is an ArgumentError living OUTSIDE Lasem::Error (lasem-ruby errmodel-1),
          # so we deliberately rescue StandardError rather than Lasem::Error.
          raise Errors::RenderingFailed.new(format, e)
        end

        # True only when this is a non-Opal runtime, the `lasem` gem loads,
        # and its native extension reports itself available. Never raises.
        def available?
          return false if RUBY_ENGINE == "opal"

          @load_error = nil
          load_gem && ::Lasem.native_available?
        rescue StandardError => e
          @load_error = e
          false
        end

        # The load failure behind the last unavailable? answer, for diagnostics.
        def load_error
          @load_error
        end

        def load_gem
          require "lasem" unless RUBY_ENGINE == "opal"
          true
        rescue LoadError => e
          @load_error = e
          false
        end
      end
    end
  end
end
