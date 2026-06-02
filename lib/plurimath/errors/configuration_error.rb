# frozen_string_literal: true

module Plurimath
  class ConfigurationError < Error
    def initialize(type, value: nil, supported: nil)
      @type = type
      @value = value
      @supported = supported
      super(message)
    end

    def message
      case @type
      when :unsupported_deprecation_behavior
        "unsupported deprecation behavior: #{@value.inspect}; " \
        "expected one of #{@supported.inspect}"
      when :missing_deprecation_feature
        "deprecation feature must be provided"
      when :mutually_exclusive_formatter_options
        "formatter options are mutually exclusive: #{@supported.inspect}"
      else
        "invalid Plurimath configuration"
      end
    end
  end
end
