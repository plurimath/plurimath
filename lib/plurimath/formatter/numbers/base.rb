# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class Base
        def interpolate(string, value, orientation = :right)
          value  = value.to_s
          length = value.length
          start  = orientation == :left ? 0 : -length

          string = string.dup
          string = string.ljust(length, '#') if string.length < length
          string[start, length] = value
          string.gsub('#', '')
        end
      end
    end
  end
end