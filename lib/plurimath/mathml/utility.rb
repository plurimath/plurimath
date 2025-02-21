# frozen_string_literal: true

require_relative "utility/empty_defined_methods"
require_relative "utility/formula_transformation"

module Plurimath
  class Mathml
    module Utility
      include EmptyDefinedMethods
      include FormulaTransformation

      attr_accessor :temp_mathml_order

      def element_order=(value)
        @temp_mathml_order = Array(validated_order(value&.map(&:name)))
      end

      def clear_temp_order
        @temp_mathml_order.shift(@temp_mathml_order.count)
      end

      def mathvariant=(value)
        return if value.nil? || value.empty?
        return unless Plurimath::Utility::FONT_STYLES.key?(value.to_sym)

        @temp_mathml_order = [
          Plurimath::Utility::FONT_STYLES[value.to_sym].new(
            nil,
            value,
          ),
        ]
      end

      def accent=(value)
        return if value.nil? || value.empty?

        @options = Hash(@options).merge(accent: true)
      end

      def accentunder=(value)
        return if value.nil? || value.empty?

        @options = Hash(@options).merge(accentunder: true)
      end

      def bevelled=(value)
        return if value.nil? || value.empty?

        @options = (@options || {}).merge(bevelled: value)
      end

      def linebreak=(value)
        return if value.nil? || value.empty?

        @temp_mathml_order << Plurimath::Math::Function::Linebreak.new(
          nil,
          { linebreak: value },
        )
      end

      def linebreakstyle=(value)
        return if value.nil? || value.empty?

        linebreak_object = @temp_mathml_order.find do |object|
          object.is_a?(Math::Function::Linebreak)
        end
        linebreak_object.attributes[:linebreakstyle] = value if linebreak_object
      end

      def linethickness=(value)
        return if value.nil? || value.empty?

        @options = (@options || {}).merge(linethickness: value)
      end

      def notation=(value)
        return if value.nil? || value.empty?

        @parameter_one = value
      end

      def mi_value=(value)
        return if value.nil? || value.empty?

        update_temp(
          replace_order_with_value(
            @temp_mathml_order,
            validate_symbols(value),
            "mi",
          ),
        )
      end

      def mo_value=(value)
        return if value.nil? || value.empty?

        update_temp(
          replace_order_with_value(
            @temp_mathml_order,
            validate_symbols(value),
            "mo",
          ),
        )
      end

      def mn_value=(value)
        return if value.nil? || value.empty?

        update_temp(
          replace_order_with_value(
            @temp_mathml_order,
            value,
            "mn",
          ),
        )
      end

      def ms_value=(value)
        return if value.nil? || value.empty?

        update_temp(
          replace_order_with_value(
            @temp_mathml_order,
            Array(value),
            "ms",
          ),
        )
      end

      def mtext_value=(value)
        return if value.nil? || value.empty?

        update_temp(
          replace_order_with_value(
            @temp_mathml_order,
            Array(value),
            "mtext",
          ),
        )
      end

      def mrow_value=(value)
        return if value.nil? || value.empty?

        update_temp(
          replace_order_with_value(
            @temp_mathml_order,
            filter_values(value, array_to_instance: true),
            "mrow",
          ),
        )
      end

      def mstyle_value=(value)
        return if value.nil? || value.empty?

        update_temp(
          replace_order_with_value(
            @temp_mathml_order,
            Array(value),
            "mstyle",
          ),
        )
      end

      def mfrac_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "mfrac")
      end

      def munderover_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "munderover")
      end

      def msubsup_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "msubsup")
      end

      def munder_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "munder")
      end

      def mover_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "mover")
      end

      def msup_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "msup")
      end

      def msub_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "msub")
      end

      def mtable_value=(value)
        return if value.nil? || value.empty?

        if respond_to?(:value)
          self.value = replace_order_with_value(
            self.value,
            update_temp_mathml_values(value),
            "mtable",
          )
        else
          update_temp_order(value, "mtable")
        end
      end

      def msqrt_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "msqrt")
      end

      def mfenced_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "mfenced")
      end

      def mroot_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "mroot")
      end

      def msgroup_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "msgroup")
      end

      def mscarries_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "mscarries")
      end

      def msline_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "msline")
      end

      def msrow_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "msrow")
      end

      def mspace_value=(value)
        return if value.nil? || value.empty?

        if value.first.linebreak
          linebreak = Math::Function::Linebreak.new(
            nil,
            { linebreak: value.first.linebreak },
          )
          update_temp_order([linebreak], "mspace")
        else
          @temp_mathml_order&.delete("mspace")
        end
      end

      def semantics_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "semantics")
      end

      def mstack_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "mstack")
      end

      def merror_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "merror")
      end

      def mlongdiv_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "mlongdiv")
      end

      def none_value=(_)
        @temp_mathml_order&.delete("none")
      end

      def mscarry_value=(value)
        return if value.nil? || value.empty?

        @temp_mathml_order&.delete("mscarry")
      end

      def menclose_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "menclose")
      end

      def maligngroup_value=(_)
        @temp_mathml_order&.delete("maligngroup")
      end

      def malignmark_value=(_)
        @temp_mathml_order&.delete("malignmark")
      end

      def mpadded_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "mpadded")
      end

      def mfraction_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "mfraction")
      end

      def mlabeledtr_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "mlabeledtr")
      end

      def mmultiscripts_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "mmultiscripts")
      end

      def mphantom_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "mphantom")
      end

      def mglyph_value=(value)
        return if value.nil? || value.empty?

        update_temp_order(value, "mglyph")
      end

      def rspace=(value)
        return if value.nil? || value.empty?

        @options = Hash(@options).merge(rspace: value)
      end
    end
  end
end
