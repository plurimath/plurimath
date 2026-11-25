# frozen_string_literal: true

module Plurimath
  module Errors
    class RenderingUnavailable < Plurimath::Error
      def initialize(load_error = nil, engine: :lasem)
        @load_error = load_error
        @engine = engine.to_s.downcase.to_sym
        super(message)
      end

      def message
        return lasem_message if @engine == :lasem
        return logifos_message if @engine == :logifos

        "[plurimath] Image rendering requires the #{@engine.inspect} engine, " \
          "which is unavailable here."
      end

      private

      def lasem_message
        text =
          "[plurimath] Image rendering requires the optional `lasem` gem with " \
          "its native extension, which is unavailable here (it is never " \
          "available under Opal/plurimath-js). Add `gem \"lasem\"` to your " \
          "Gemfile, then run `bundle exec lasem-doctor` to diagnose missing " \
          "system libraries (cairo, pango, the Lasem C library) and rebuild " \
          "the extension."
        return text unless @load_error

        "#{text} Underlying load error: #{@load_error.message}"
      end

      def logifos_message
        text =
          "[plurimath] Rendering with the logifos engine requires the " \
          "optional `logifos` gem with a native logifos library, which is " \
          "unavailable here (it is never available under Opal/plurimath-js). " \
          "Add `gem \"logifos\"` to your Gemfile and pass `library_path:` " \
          "(the logifos native library) and `fonts:` (the grading fonts) to " \
          "render."
        return text unless @load_error

        "#{text} Underlying load error: #{@load_error.message}"
      end
    end
  end
end
