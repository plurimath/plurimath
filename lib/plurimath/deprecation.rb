# frozen_string_literal: true

module Plurimath
  module Deprecation
    BEHAVIORS = %i[warn raise silence].freeze
    DEFAULT_BEHAVIOR = :warn

    class << self
      def warn(feature:, message: nil, replacement: nil, since: nil, remove_in: nil)
        feature = validate_feature(feature)
        return if behavior == :warn && emitted_features[feature]

        emit(
          feature: feature,
          message: message,
          replacement: replacement,
          since: since,
          remove_in: remove_in,
        )
      end

      def behavior
        @behavior ||= DEFAULT_BEHAVIOR
      end

      def behavior=(behavior)
        @behavior = validate_behavior(behavior)
      end

      private

      def emit(feature:, message:, replacement:, since:, remove_in:)
        case behavior
        when :silence
          nil
        when :raise
          raise DeprecationError.new(
            feature: feature,
            message: message,
            replacement: replacement,
            since: since,
            remove_in: remove_in,
          )
        when :warn
          error = DeprecationError.new(
            feature: feature,
            message: message,
            replacement: replacement,
            since: since,
            remove_in: remove_in,
          )
          Kernel.warn(error.message)
          emitted_features[feature] = true
        end
      end

      def emitted_features
        @emitted_features ||= {}
      end

      def validate_behavior(behavior)
        return behavior if BEHAVIORS.include?(behavior)

        raise ConfigurationError.new(
          :unsupported_deprecation_behavior,
          value: behavior,
          supported: BEHAVIORS,
        )
      end

      def validate_feature(feature)
        feature = feature.to_s
        return feature unless feature.empty?

        raise ConfigurationError.new(:missing_deprecation_feature)
      end
    end
  end
end
