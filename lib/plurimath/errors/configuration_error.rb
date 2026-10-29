# frozen_string_literal: true

module Plurimath
  class ConfigurationError < Error
    def initialize(type, value: nil, supported: nil, option: nil)
      @type = type
      @value = value
      @supported = supported
      @option = option
      super(message)
    end

    def message
      case @type
      when :unsupported_deprecation_behavior
        "unsupported deprecation behavior: #{@value.inspect}; " \
        "expected one of #{@supported.inspect}"
      when :missing_deprecation_feature
        "deprecation feature must be provided"
      when :conflicting_formatter_options
        "formatter options cannot be used together: choose either " \
        ":padding_digits or :padding_group_digits"
      when :invalid_formatter_option
        "invalid value #{@value.inspect} for formatter option " \
        "#{@option.inspect}#{" (expected #{@supported})" if @supported}"
      else
        "invalid Plurimath configuration"
      end
    end
  end
end
