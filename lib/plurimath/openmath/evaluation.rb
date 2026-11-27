# frozen_string_literal: true

module Plurimath
  class Openmath
    # Evaluation of the pmquant content dictionary (plurimath#583). The
    # openmath gem owns the binding table (pmquant/ustd, uexp, ucov, value)
    # and the quantity semantics; a Formula parsed from OpenMath that uses a
    # pmquant symbol evaluates from its retained source, so the symbol binds
    # through the CD rather than through a case statement here. Gem
    # refusals surface as Plurimath's typed evaluation errors.
    module Evaluation
      CD = "pmquant"
      CD_ATTRIBUTE = /\bcd\s*=\s*["']pmquant["']/

      module_function

      def applies?(formula)
        source = formula.openmath_source
        source && formula.openmath_source_current? &&
          source.to_xml.match?(CD_ATTRIBUTE)
      end

      def evaluate(formula, bindings)
        result = ::Openmath::Evaluation::Evaluator.evaluate(
          formula.openmath_source, variables: bindings
        )
        build_result(result)
      rescue ::Openmath::Evaluation::UnboundSymbolError => e
        raise Errors::Evaluation::MissingVariableError, e.name if e.cd == "(variable)"

        raise Errors::Evaluation::UnsupportedExpressionError, e.message
      rescue ::Openmath::Evaluation::Error => e
        raise Errors::Evaluation::UnsupportedExpressionError, e.message
      end

      def build_result(result)
        case result
        when ::Openmath::Evaluation::Uncertain
          Math::Evaluation::Result.new(value: result.value, quantity: result)
        when Numeric
          Math::Evaluation::Result.new(value: result)
        else
          raise Errors::Evaluation::UnsupportedExpressionError,
                "#{result.class} is not a numeric result"
        end
      end
    end
  end
end
