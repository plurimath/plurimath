# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class UnaryFunction
        attr_accessor :parameter_one

        def initialize(parameter_one = nil)
          @parameter_one = parameter_one
        end

        def ==(object)
          object.class == self.class &&
            object.parameter_one == parameter_one
        end

        def to_asciimath
          "#{class_name}#{value_to_asciimath}"
        end

        def value_to_asciimath
          "(#{parameter_one.to_asciimath})" unless parameter_one.nil?
        end

        def to_mathml_without_math_tag
          "<mi>#{class_name}</mi>"
        end

        def to_latex
          first_value = "{#{parameter_one.to_latex}}" if parameter_one
          "\\#{class_name}#{first_value}"
        end

        def class_name
          self.class.name.split("::").last.downcase
        end
      end
    end
  end
end
