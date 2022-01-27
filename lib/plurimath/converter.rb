# frozen_string_literal: true

require_relative 'converters/unicode'
require_relative 'converters/asciimath'
require_relative 'converters/omml'
require_relative 'converters/mathml'
require_relative 'converters/html'
require_relative 'converters/latex'
require_relative 'converters/unitsml'
# Impletemented converter gems
module Plurimath
  class Error < StandardError; end

  VALID_TYPES = %w[unicode asciimath omml mathml html latex].freeze

  def parse(str, type: nil)
    raise_error! unless (type.is_a?(Symbol) || type.is_a?(String)) && VALID_TYPES.include?(type.to_s)

    klass = Object.const_get(type.capitalize.to_s)
    klass.new(str)
  end

  private

  def raise_error!
    raise Error.new('Type is not valid, please enter string or symbol')
  end

  module_function :parse, :raise_error!
end
