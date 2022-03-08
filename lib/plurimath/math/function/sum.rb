# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Sum
        attr_accessor :base, :exponent, :content

        def initialize(base = nil, exponent = nil, content = nil)
          @base = base
          @exponent = exponent
          @content = content
        end

        def to_asciimath
          "sum#{sum_content.empty? ? content.to_asciimath : sum_content}"
        end

        def sum_content
          "#{base_to_s}#{exponent_to_s}"
        end

        def base_to_s
          "_#{base.to_asciimath}" unless base.nil?
        end

        def exponent_to_s
          "^#{exponent.to_asciimath}" unless exponent.nil?
        end
      end
    end
  end
end
