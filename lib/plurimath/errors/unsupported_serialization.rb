# frozen_string_literal: true

module Plurimath
  module Errors
    # A deliberate refusal to serialize a construct without losing its meaning.
    class UnsupportedSerialization < Plurimath::Error; end
  end
end
