# frozen_string_literal: true

module Plurimath
  class DeprecationError < Error
    SEVERITY = :warning

    attr_reader :feature, :replacement, :since, :remove_in

    def initialize(feature:, message: nil, replacement: nil, since: nil,
remove_in: nil)
      @feature = feature
      @replacement = replacement
      @since = since
      @remove_in = remove_in
      @user_message = message
      super(to_s)
    end

    def severity
      SEVERITY
    end

    def to_s
      deprecation = "[plurimath][DEPRECATION] #{feature} is deprecated"
      deprecation = "#{deprecation} since #{since}" if since
      deprecation = "#{deprecation} and will be removed in #{remove_in}" if remove_in

      parts = [deprecation]
      parts << "Use #{replacement} instead" if replacement
      parts << @user_message if @user_message
      "#{parts.join('. ')}."
    end
  end
end
