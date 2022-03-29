# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Log
        attr_accessor :base, :exponent

        def initialize(base = nil, exponent = nil)
          @base = base
          @exponent = exponent
        end

        def ==(object)
          object.base == base && object.exponent == exponent
        end

        def to_asciimath
          "log#{log_content.empty? ? content&.to_asciimath : log_content}"
        end

        def log_content
          "#{base_to_s}#{exponent_to_s}"
        end

        def base_to_s
          "_#{base&.to_asciimath}" unless base.nil?
        end

        def exponent_to_s
          "^#{exponent&.to_asciimath}" unless exponent.nil?
        end
      end
    end
  end
end
