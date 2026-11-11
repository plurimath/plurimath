# frozen_string_literal: true

require "unitsml"

module Plurimath
  module EvaluationRequest
    # Serialized exact quantity profile. Formula evaluation and unit
    # conversion are owned by QuantityEvaluator and UnitsML respectively.
    module Quantity
      ENGINE = "plurimath.quantity/1"
      MAX_BINDINGS = 256
      MAX_UNIT_BYTES = 4096
      BINDING_DECIMAL = /\A-?[0-9]+(?:\.[0-9]+)?\z/
      EVALUATION = Plurimath::Errors::Evaluation
      UNIT_ERRORS = ::Unitsml::Errors

      class Refusal < StandardError
        attr_reader :wire

        def initialize(wire)
          @wire = wire
          super(wire.fetch("code"))
        end
      end

      class Evaluator < Math::Evaluation::QuantityEvaluator
        def add(left, right)
          if left.scale == :difference && right.scale != :difference
            return super(right, left)
          end

          super
        end

        def subtract(left, right)
          if Quantity.dimensions(left) == Quantity.dimensions(right) &&
              left.scale == :difference && right.scale != :difference
            Quantity.scale_error("difference minus absolute", "Difference")
          end

          super
        end

        def power(base, exponent)
          unsupported("quantity powers need a dimensionless integer exponent") unless Quantity.dimensions(exponent)&.empty?
          magnitude = Quantity.canonical_magnitude(exponent)
          unsupported("quantity powers need a dimensionless integer exponent") unless magnitude.denominator == 1
          power = magnitude.numerator.abs
          Quantity.refuse("ResourceLimitError", "ResourceLimit") if power > 4096
          Quantity.scale_error("power") if base.scale == :interval
          factor = Quantity.conversion(base.formula).factor
          width = [base.value.numerator, base.value.denominator, factor.numerator, factor.denominator]
            .map { |number| number.abs.bit_length }.max
          Quantity.refuse("ResourceLimitError", "ResourceLimit") if width * power > 1_000_000

          super(base, ::Unitsml::Quantity.new(value: magnitude))
        end

        private

        def quantity(value)
          return value if value.is_a?(::Unitsml::Quantity) && Quantity.dimensionless_identity?(value.formula)

          super
        end
      end

      module_function

      def call(request)
        envelope = {"schema" => QUANTITY_SCHEMA, "engine" => ENGINE, "grammar" => GRAMMAR}
        EvaluationRequest.keys!(request, %w[schema ast bindings mode convert_to], %w[schema ast])
        EvaluationRequest.invalid! unless request.fetch("mode", "strict") == "strict"
        document = EvaluationRequest.formula(request["ast"])
        result = Evaluator.new(document, bindings(request.fetch("bindings", {}))).evaluate
        converted = convert(result.value, request["convert_to"]) if request.key?("convert_to")
        EvaluationRequest.canonical(envelope.merge("ok" => true, "result" => {
          "value" => snapshot(result.value), "converted" => converted && snapshot(converted),
          "accuracy" => {"symbol" => "exact"},
        }))
      rescue InvalidRequest
        failure(envelope, "code" => "InvalidRequest")
      rescue Refusal => error
        failure(envelope, error.wire)
      rescue UNIT_ERRORS::ParseError => error
        failure(envelope, "code" => "UnitSyntaxError", "parser" => syntax(error))
      rescue UNIT_ERRORS::IndeterminateResultError, EVALUATION::DivisionByZeroError
        failure(envelope, "code" => "DivisionByZeroError", "class" => "indeterminate", "detail" => "DivisionByZero")
      rescue UNIT_ERRORS::DimensionMismatchError
        failure(envelope, "code" => "DimensionMismatchError", "class" => "error", "detail" => "DimensionMismatch")
      rescue UNIT_ERRORS::ScaleOperationError => error
        operation = error.message.split.first
        failure(envelope, "code" => "ScaleOperationError", "class" => "error",
                "detail" => scale_detail(operation, "Interval"))
      rescue EVALUATION::MissingVariableError, EVALUATION::UnsupportedExpressionError,
             EVALUATION::InvalidBindingError => error
        failure(envelope, "code" => error.class.name.split("::").last)
      end

      def bindings(raw)
        EvaluationRequest.invalid! unless raw.is_a?(Hash)
        refuse("ResourceLimitError", "ResourceLimit") if raw.size > MAX_BINDINGS
        raw.sort.to_h do |name, value|
          EvaluationRequest.invalid! unless name.match?(NAME)
          [name, binding(value)]
        end
      end

      def binding(value)
        return magnitude(value) if value.is_a?(String)

        EvaluationRequest.keys!(value, %w[value unit difference], %w[value unit])
        number = magnitude(value["value"])
        formula = unit_formula(value["unit"])
        difference = value.fetch("difference", false)
        EvaluationRequest.invalid! unless [true, false].include?(difference)

        ::Unitsml::Quantity.new(value: number, unit: formula, scale: (:difference if difference))
      end

      def magnitude(text)
        EvaluationRequest.invalid! unless text.is_a?(String)
        refuse("InvalidBindingError") unless text.match?(BINDING_DECIMAL)
        refuse("ResourceLimitError", "ResourceLimit") if text.bytesize > 8192
        Rational(text)
      end

      def unit_formula(text)
        EvaluationRequest.invalid! unless text.is_a?(String) && !text.empty?
        refuse("ResourceLimitError", "ResourceLimit") if text.bytesize > MAX_UNIT_BYTES
        formula = ::Unitsml.parse(text)
        conversion(formula)
        formula
      end

      def convert(quantity, expression)
        target = unit_formula(expression)
        quantity.convert_to(target)
      end

      def conversion(formula)
        if formula.nil? || dimensionless_identity?(formula)
          return ::Unitsml::Conversion::Result.new(factor: 1r, offset: 0r)
        end

        canonical = ::Unitsml::Conversion.to_canonical(formula)
        if canonical.factor.is_a?(Float) || canonical.offset.is_a?(Float)
          refuse("InexactUnitPowerError", "InexactPower")
        end

        canonical
      rescue UNIT_ERRORS::ConversionError => error
        case error.message
        when /affine/ then refuse("AffineCompositionError", "AffineComposition")
        when /no canonical conversion path for (.+)\z/
          record = ::Unitsml::Unitsdb.units.find_by_name(JSON.parse(Regexp.last_match(1)))
          id = ::Unitsml::Utility.canonical_nist_id(record)
          refuse("MissingUnitConversionError", "MissingConversion(#{id.to_json})") if id
          raise
        else
          raise
        end
      end

      def dimensionless_identity?(formula)
        return false unless formula

        unit = formula.value.first
        formula.value.size == 1 && unit.is_a?(::Unitsml::Unit) &&
          ::Unitsml::Utility.canonical_nist_id(unit.unit_instance) == "NISTu61" && unit.prefix.nil?
      end

      def canonical_magnitude(quantity)
        canonical = conversion(quantity.formula)
        quantity.value.to_r * canonical.factor + (quantity.scale == :difference ? 0 : canonical.offset)
      end

      def dimensions(quantity)
        dimensionless_identity?(quantity.formula) ? {} : quantity.dimension_vector
      end

      def snapshot(quantity)
        dimensions = dimensions(quantity)
        refuse("UnsupportedUnitExpressionError", "UnsupportedOperand") if dimensions.nil?
        {"magnitude" => exact_text(quantity.value),
         "canonical_magnitude" => exact_text(canonical_magnitude(quantity)),
         "dimension_id" => (quantity.dimension_id unless dimensions.empty?),
         "dimensions" => dimensions.transform_values { |power| exact_text(power) },
         "scale" => quantity.scale.to_s, "terms" => terms(quantity.formula)}
      end

      def terms(formula)
        return [] unless formula

        powers = Hash.new(0)
        ::Unitsml::Compose::TermTree.each_leaf(formula) do |node|
          next unless node.is_a?(::Unitsml::Unit)

          id = ::Unitsml::Utility.canonical_nist_id(node.unit_instance)
          refuse("UnsupportedUnitExpressionError", "UnsupportedOperand") if id.nil?
          power = node.power_numerator
          power = power.value while power.is_a?(::Unitsml::Fenced)
          exponent = power.nil? ? 1 : Rational(power.raw_value.to_s)
          powers[[id, node.prefix&.id]] += exponent
        end
        powers.sort_by { |(unit, prefix), _| [unit, prefix.to_s] }.filter_map do |(unit, prefix), power|
          {"unit" => unit, "prefix" => prefix, "power" => exact_text(power)} unless power.zero?
        end
      end

      def exact_text(value)
        exact = value.to_r
        exact.denominator == 1 ? exact.numerator.to_s : exact.to_s
      end

      def syntax(error)
        cause = error.cause.parse_failure_cause
        artifact = ::Unitsml::Parser.artifact
        cause = artifact.deepest_cause(cause)
        line, column = cause.source.line_and_column(cause.position)
        expected = artifact.expected_labels_for(cause)
        if expected.empty?
          message = Array(cause.message).join
          labels = message[/\AFailed to match: expected one of \[(.*)\]\z/m, 1]
          expected = labels.split(", ") if labels
        end
        {"category" => "syntax", "byte_offset" => cause.position,
         "line" => line, "column" => column, "expected" => expected}
      end

      def scale_detail(operation, scale)
        "ScaleOperation { scale: #{scale}, operation: #{operation.to_json} }"
      end

      def scale_error(operation, scale = "Interval")
        refuse("ScaleOperationError", scale_detail(operation, scale))
      end

      def refuse(code, detail = nil)
        wire = {"code" => code}
        wire.merge!("class" => "error", "detail" => detail) if detail
        raise Refusal, wire
      end

      def failure(envelope, error)
        EvaluationRequest.canonical(envelope.merge("ok" => false, "error" => error))
      end
    end
  end
end
