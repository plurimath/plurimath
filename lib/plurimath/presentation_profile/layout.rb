# frozen_string_literal: true

module Plurimath
  class PresentationProfile
    # Writer policies for layout that has no explicit source instruction.
    class Layout
      FRACTIONS = { vertical: "bar", slanted: "skw", inline: "lin" }.freeze
      LIMITS = { above_below: "undOvr", side: "subSup" }.freeze
      private_constant :FRACTIONS, :LIMITS

      def initialize(fraction, sum, integral)
        @fraction = choice(fraction, FRACTIONS, "fraction_layout")
        @sum = choice(sum, LIMITS, "sum_limits")
        @integral = choice(integral, LIMITS, "integral_limits")
        freeze
      end

      def mathml_fraction(element, source)
        return element unless fraction?(source)
        if @fraction != "lin"
          element["bevelled"] = (@fraction == "skw").to_s
          return element
        end

        # Parenthesize both operands: (a+b)/(c+d) must preserve grouping.
        row = XmlHelper.ox_element("mrow")
        numerator, denominator = element.nodes
        XmlHelper.update_nodes(row, [operator("("), numerator, operator(")"),
                                    operator("/"), operator("("), denominator, operator(")")])
      end

      def omml_fraction(properties, source)
        return properties unless fraction?(source)

        type = XmlHelper.ox_element("type", namespace: "m", attributes: { "m:val": @fraction })
        # The selected type precedes ctrlPr in the Open XML property sequence.
        existing = properties.nodes.find { |node| node.respond_to?(:name) && node.name == "m:type" }
        if existing
          existing.remove_attr("m:val")
          existing.remove_attr("val")
          existing.set_attr("m:val" => @fraction)
        else
          properties.insert_in_nodes(0, type)
        end
        properties
      end

      def limits(source, kind)
        return if source.respond_to?(:options) && source.options&.key?(:type)

        case kind
        when :sum then @sum
        when :integral then @integral
        end
      end

      def nary_kind(source)
        symbol = Utility.html_entity_to_unicode(source.parameter_one&.nary_attr_value(options: {}))
        return :sum if symbol == "∑"
        return :integral if %w[∫ ∬ ∭ ⨌ ∮ ∯ ∰].include?(symbol)
      end

      def mathml_limits(source, kind)
        location = limits(source, kind)
        return unless location

        lower, upper = if source.is_a?(Math::Function::Nary)
                         [source.parameter_two, source.parameter_three]
                       else
                         [source.parameter_one, source.parameter_two]
                       end
        tag = if lower && upper
                location == "subSup" ? "msubsup" : "munderover"
              elsif lower
                location == "subSup" ? "msub" : "munder"
              elsif upper
                location == "subSup" ? "msup" : "mover"
              else
                "mrow"
              end
        XmlHelper.ox_element(tag)
      end

      def to_omml_math_properties
        root = XmlHelper.ox_element("mathPr", namespace: "m", attributes: {
          "xmlns:m": "http://schemas.openxmlformats.org/officeDocument/2006/math",
        })
        { "intLim" => @integral, "naryLim" => @sum }.each do |name, value|
          next unless value

          root << XmlHelper.ox_element(name, namespace: "m", attributes: { "m:val": value })
        end
        Plurimath.xml_engine.dump(root, indent: 2)
      end

      private

      def choice(value, choices, name)
        return if value.nil?
        return choices.fetch(value) if choices.key?(value)

        raise ArgumentError, "Unknown #{name}: #{value.inspect}"
      end

      def fraction?(source)
        @fraction && !source.hide_function_name &&
          (source.options.nil? || (source.options.keys & %i[bevelled linethickness ldiv choose]).empty?)
      end

      def operator(text)
        XmlHelper.ox_element("mo") << text
      end
    end
  end
end
