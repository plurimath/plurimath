# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      # The outcome of one evaluation: the value, every accuracy boundary
      # crossed (or deferred against), and the subtrees left unevaluated
      # when strict mode stopped at a boundary.
      #
      # value: a Numeric (Integer/Rational exact, Float/BigDecimal past a
      # boundary), true/false for a relation1/logic1 verdict, or nil when
      # strict mode deferred.
      #
      # boundaries: ordered records
      #   { operation:, operands:, operand_accuracy:, action:, result: }
      #   with action :approximated (crossed, float computed), :guarded
      #   (crossed, BigDecimal to declared digits), or :deferred (refused,
      #   strict mode).
      #
      # unevaluated: norm-text of subtrees left symbolic in strict mode.
      class Result
        # quantity: the uncertain quantity (Openmath::Evaluation::Uncertain)
        # when the expression constructs one through the pmquant CD; value
        # is then its reported value and quantity keeps the category.
        attr_reader :value, :boundaries, :unevaluated, :quantity

        def initialize(value:, boundaries: [], unevaluated: [], quantity: nil)
          @quantity = quantity
          @value = value
          @boundaries = boundaries.freeze
          @unevaluated = unevaluated.freeze
        end

        def exact?
          !value.nil? && Accuracy.exact?(value) &&
            boundaries.none? { |boundary| boundary[:action] == :approximated }
        end

        def deferred?
          value.nil?
        end

        def ==(other)
          other.is_a?(Result) && value == other.value &&
            boundaries == other.boundaries && quantity == other.quantity &&
            unevaluated == other.unevaluated
        end
      end
    end
  end
end
