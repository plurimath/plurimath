# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      # Orchestrates Source and Parts through numeric transforms and final
      # renderers; low-level digit rules stay in composed helpers.
      class NumberRenderer
        attr_reader :options, :source

        def initialize(source, options)
          @source = source
          @options = options
          @base_notation = BaseNotation.new(@options)
          @integer_format = Integer.new(@options)
          @fraction_format = Fraction.new(@options)
          @significant_format = Significant.new(@options)
          @parts_renderer = PartsRenderer.new(
            integer_formatter: @integer_format,
            fraction_formatter: @fraction_format,
          )
          @sign_renderer = SignRenderer.new(@options.number_sign)
        end

        def format(precision: nil)
          render_precision = precision || options.precision || source_precision
          parts = source.to_parts(
            base: options.base,
            precision: render_precision,
          )
          format_parts(parts, precision: render_precision)
        end

        def format_parts(parts, precision:)
          parts = parts.with_digits(
            fraction_digits: parts.fraction_digits[0...precision.to_i].to_s,
          )
          parts = renderable_parts(parts, precision: precision)

          parts = significant_format.apply_parts(parts) if significant_format.active?
          result = parts_renderer.render(parts)

          sign_renderer.apply(parts, base_notation.apply(result))
        end

        private

        attr_reader :base_notation, :fraction_format, :integer_format,
                    :parts_renderer, :significant_format, :sign_renderer

        def renderable_parts(parts, precision:)
          parts = parts.with_digits(
            integer_digits: integer_format.number_to_base(parts.integer_digits),
          )
          fraction_format.apply_parts(parts, precision: precision)
        end

        def source_precision
          return 0 if source.decimal.fix == source.decimal

          source.fraction_digits.length
        end
      end
    end
  end
end
