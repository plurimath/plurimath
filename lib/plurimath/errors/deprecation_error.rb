# frozen_string_literal: true

module Plurimath
  class DeprecationError < Error
    def initialize(feature:, message: nil, replacement: nil, since: nil, remove_in: nil)
      super(
        build_message(
          feature: feature,
          message: message,
          replacement: replacement,
          since: since,
          remove_in: remove_in,
        ),
      )
    end

    private

    def build_message(feature:, message:, replacement:, since:, remove_in:)
      deprecation = "[plurimath][DEPRECATION] #{feature} is deprecated"
      deprecation = "#{deprecation} since #{since}" if since
      deprecation = "#{deprecation} and will be removed in #{remove_in}" if remove_in

      parts = [deprecation]
      parts << "Use #{replacement} instead" if replacement
      parts << message if message
      "#{parts.join('. ')}."
    end
  end
end
