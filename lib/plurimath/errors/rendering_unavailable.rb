# frozen_string_literal: true

module Plurimath
  module Errors
    class RenderingUnavailable < Plurimath::Error
      def initialize(load_error = nil)
        @load_error = load_error
        super(message)
      end

      def message
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
    end
  end
end
