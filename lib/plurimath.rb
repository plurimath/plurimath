# frozen_string_literal: true

require 'byebug'
require 'bundler/setup'
require 'asciimath2unitsml'
require 'unicode2latex'
require 'omml2mathml'
require 'mathml2asciimath'
require 'html2asciimath'
require 'latexmath'
require_relative 'converters/mathml_object'

# Impletemented converter gems
module Plurimath
  class Error < StandardError; end

  VALID_MATHS = %w[unicode asciimath omml mathml html latex].freeze

  def self.parse(str, type: nil)
    raise_error! unless (type.is_a?(Symbol) || type.is_a?(String)) && VALID_MATHS.include?(type.to_s)
    require_relative "converters/#{type}"
    object = Object.const_get(type.capitalize.to_s)
    object.new(str)
  end

  def self.raise_error!
    throw Error.new('Type is not valid, please enter string or symbol')
  end
end
