# frozen_string_literal: true

module Plurimath
  module Math
    class Number < Core
      attribute :value, :string
      attribute :mini_sub_sized, :boolean, default: -> { false }
      attribute :mini_sup_sized, :boolean, default: -> { false }
      attribute :base, :integer

      def initialize(value = nil, mini_sub_sized: false, mini_sup_sized: false,
                     base: nil, lutaml_register: nil)
        @lutaml_register = lutaml_register if lutaml_register
        @using_default = {}
        @value = Utility.parser_slice?(value) ? value.to_s : value
        @mini_sub_sized = mini_sub_sized
        @mini_sup_sized = mini_sup_sized
        @base = base
      end

      def ==(object)
        object.is_a?(Number) &&
          object.value == value &&
          object.mini_sub_sized == mini_sub_sized &&
          object.mini_sup_sized == mini_sup_sized &&
          object.base == base
      end

      def element_order=(*); end

      def to_asciimath(options:)
        return value.to_s unless number_formatter(options)

        Formatter::Numbers::TextRenderer.render(
          format_value_with_options(options), :asciimath
        )
      end

      def to_mathml_without_math_tag(_, options:)
        return XmlHelper.ox_element("mn") << value.to_s unless number_formatter(options)

        Formatter::Numbers::MathmlRenderer.render(format_value_with_options(options))
      end

      def to_latex(options:)
        return value.to_s unless number_formatter(options)

        Formatter::Numbers::TextRenderer.render(
          format_value_with_options(options), :latex
        )
      end

      def to_html(options:)
        return value.to_s unless number_formatter(options)

        Formatter::Numbers::TextRenderer.render(
          format_value_with_options(options), :html
        )
      end

      def to_omml_without_math_tag(_, options:)
        unless number_formatter(options)
          return [XmlHelper.ox_element("t", namespace: "m") << value.to_s]
        end

        [Formatter::Numbers::OmmlRenderer.render(format_value_with_options(options))]
      end

      def to_unicodemath(options:)
        return mini_sub if mini_sub_sized
        return mini_sup if mini_sup_sized
        return value.to_s unless number_formatter(options)

        Formatter::Numbers::TextRenderer.render(
          format_value_with_options(options), :unicodemath
        )
      end

      def insert_t_tag(_, options:)
        [
          XmlHelper.ox_element("r", namespace: "m") << t_tag(options: options),
        ]
      end

      def font_style_t_tag(_, options:)
        t_tag(options: options)
      end

      def t_tag(options:)
        XmlHelper.ox_element("t",
                           namespace: "m") << formatted_value(options)
      end

      def nary_attr_value(options:)
        format_value_with_options(options).to_s
      end

      def validate_function_formula
        false
      end

      def evaluate(evaluator)
        evaluator.number_value(value.to_s)
      end

      def mini_sized?
        mini_sub_sized || mini_sup_sized
      end

      def value=(value)
        @value = value.is_a?(Array) ? value.join : value
      end

      protected

      def mini_sub
        unicode_const(:SUB_DIGITS)[value.to_sym]
      end

      def mini_sup
        unicode_const(:SUP_DIGITS)[value.to_sym]
      end

      def unicode_const(const)
        UnicodeMath::Constants.const_get(const)
      end

      # Without a formatter a number is written as its value, so the writers
      # above skip Formatter::Numbers and the formatter is loaded only when
      # one is used.
      def number_formatter(options)
        options.fetch(:formatter) { Plurimath.configuration.number_formatter }
      end

      def format_value_with_options(options)
        formatter = number_formatter(options)
        return value unless formatter

        format = options[:format] || {}
        format = format.merge(base: base) if base && !format.key?(:base)

        formatter.format_number(options[:formula], self, format: format)
      end

      private

      def formatted_value(options)
        format_value_with_options(options).to_s
      end
    end
  end
end
