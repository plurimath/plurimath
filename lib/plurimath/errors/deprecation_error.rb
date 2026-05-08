# frozen_string_literal: true

module Plurimath
  class DeprecationError < Error
    def initialize(feature:, message: nil, replacement: nil, since: nil, remove_in: nil)
      @feature = feature
      @message = message
      @replacement = replacement
      @since = since
      @remove_in = remove_in
      super(message)
    end

    def message
      parts = ["[plurimath][DEPRECATION] #{@feature} is deprecated"]
      parts << "since #{@since}" if @since
      parts << "and will be removed in #{@remove_in}" if @remove_in
      parts << "Use #{@replacement} instead" if @replacement
      parts << @message if @message
      message = parts.join(". ")
      message << "."
      message
    end
  end
end
