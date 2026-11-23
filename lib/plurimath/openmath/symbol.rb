# frozen_string_literal: true

module Plurimath
  class Openmath
    # An unbound CD symbol keeps its identity; presentation cannot carry its CD.
    class Symbol < Math::Symbols::Symbol
      attribute :cd, :string
      attribute :cdbase, :string

      def initialize(name = nil, **identity)
        super(name)
        @cd = identity[:cd]
        @cdbase = identity[:cdbase]
      end

      %i[to_asciimath to_latex to_html to_unicodemath
         to_mathml_without_math_tag to_omml_without_math_tag insert_t_tag].each do |method|
        define_method(method) do |*_, **_options|
          raise UnsupportedError.new("#{cd}/#{value}", :openmath)
        end
      end

      def evaluate(_evaluator)
        raise Errors::Evaluation::UnsupportedExpressionError, "#{cd}/#{value}"
      end

      def ==(other)
        super && other.is_a?(self.class) && cd == other.cd && cdbase == other.cdbase
      end
    end
  end
end
