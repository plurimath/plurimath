# frozen_string_literal: true

module Plurimath
  # Content MathML shares OpenMath's versioned semantic models and converter.
  class ContentMathml < Openmath
    def to_formula
      raise ArgumentError, "unsupported OpenMath version #{@version.inspect}" unless [2, 3].include?(@version)

      from_object(::Openmath::ContentMathML.parse(@text, version: @version))
    rescue ::Openmath::ContentMathML::Error => e
      raise UnsupportedError.new(e.message, :content_mathml)
    end
  end
end
