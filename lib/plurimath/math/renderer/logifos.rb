# frozen_string_literal: true

module Plurimath
  module Math
    module Renderer
      # The logifos backend: MathML to SVG through the `logifos` gem and its
      # native library. The caller supplies the library path and the grading
      # fonts per call — the gem ships no engine artifact and no font. See
      # Renderer::ENGINES for the shared contract.
      module Logifos
        FORMATS = %i[svg].freeze

        OPTIONS = %i[library_path fonts font_size_px display color limits].freeze

        module_function

        # The output formats this engine accepts.
        def formats
          FORMATS
        end

        # Render a MathML document to an SVG string. Engine failures (bad
        # library path, typed core refusals) wrap as RenderingFailed.
        def render(mathml, format:, **opts)
          library_path = required_option(opts, :library_path)
          fonts = required_option(opts, :fonts)
          rendered(library_path, fonts, mathml, format, opts)
        end

        # True only when this is a non-Opal runtime and the `logifos` gem
        # loads. The library and fonts are per-call inputs; a call without
        # them fails with a diagnostic, not at detection time. Never raises.
        def available?
          return false if RUBY_ENGINE == "opal"

          @load_error = nil
          load_gem
        end

        # The load failure behind the last unavailable? answer, for diagnostics.
        def load_error
          @load_error
        end

        def load_gem
          require "logifos" unless RUBY_ENGINE == "opal"
          true
        rescue LoadError => e
          @load_error = e
          false
        end

        def required_option(opts, key)
          opts.fetch(key) do
            raise ArgumentError,
                  "the logifos engine requires #{key.inspect}: pass a native " \
                  "library path and the grading fonts (Logifos::NativeRuntime.font)"
          end
        end

        def rendered(library_path, fonts, mathml, format, opts)
          runtime = ::Logifos::NativeRuntime.new(library_path: library_path)
          result = runtime.render_mathml(
            mathml,
            fonts: fonts,
            format: format,
            options: opts.slice(:font_size_px, :display, :color, :limits),
          )
          result.fetch("svg")
        rescue StandardError => e
          raise Errors::RenderingFailed.new(format, e)
        end
      end
    end
  end
end
