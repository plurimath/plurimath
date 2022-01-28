# frozen_string_literal: true

require_relative 'converters/unicode'
require_relative 'converters/asciimath'
require_relative 'converters/omml'
require_relative 'converters/mathml'
require_relative 'converters/html'
require_relative 'converters/latex'
require_relative 'converters/unitsml'
# Implemented converter gems
module Plurimath
  class Error < StandardError; end

  VALID_TYPES = {
    unicode: Unicode,
    asciimath: Asciimath,
    omml: Omml,
    mathml: Mathml,
    html: Html,
    latex: Latex
  }.freeze

  def parse(str, type:)
    raise_error! unless valid_type?(type)

    klass = VALID_TYPES[type.to_sym]
    klass.new(str)
  end

  private

  def raise_error!
    raise Plurimath::Error, Error.new('Type is not valid, please enter string or symbol')
  end

  def valid_type?(type)
    (type.is_a?(Symbol) || type.is_a?(String)) && VALID_TYPES.key?(type.to_sym)
  end

  module_function :parse, :raise_error!, :valid_type?
end
