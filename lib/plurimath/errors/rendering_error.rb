# frozen_string_literal: true

module Plurimath
  # Raised by the image-rendering path (Plurimath::Math.render / Formula#render,
  # backed by Plurimath::Math::Renderer) when the optional `lasem` gem or its
  # native extension is unavailable, the requested output format is unsupported,
  # or the underlying render fails.
  class RenderingError < Error
    def self.unsupported_format(format, supported:)
      new(
        "unsupported render format #{format.inspect}; " \
        "supported formats are #{supported.map(&:inspect).join(', ')}",
      )
    end

    def self.unavailable(cause = nil)
      message =
        "image rendering requires the optional `lasem` gem with its native " \
        "extension, which is unavailable here (it is never available under " \
        "Opal/plurimath-js). Add `gem \"lasem\"` to your Gemfile, then run " \
        "`bundle exec lasem-doctor` to diagnose missing system libraries " \
        "(cairo, pango, the Lasem C library) and rebuild the extension."
      message = "#{message} Underlying load error: #{cause.message}" if cause
      new(message)
    end

    def self.render_failed(format, cause:)
      new("failed to render MathML to #{format}: #{cause.message}")
    end
  end
end
