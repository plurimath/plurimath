# frozen_string_literal: true

module Plurimath
  class Mathml
    # Reads the measurement-uncertainty marker (plurimath#493) shared by the
    # MathML, OMML and UnicodeMath readers: the MathML `intent` of an mrow,
    # the text of the hidden OMML phantom, and the UnicodeMath ⓘ("...")
    # string. See docs/uncertainty.adoc.
    #
    #   standard-uncertainty(1.230,0.004)
    #   standard-uncertainty:concise(1.230,0.004)
    #   expanded-uncertainty(10.0,0.3,2[,0.95][,$unit])
    #   coverage-interval[:shortest|:probabilistically-symmetric](y,lo,hi,p[,$unit])
    #
    # A string that starts with one of the three concept names is a marker.
    # A marker that does not have exactly this shape raises
    # Errors::InvalidUncertainty; it is never read as ordinary content.
    module UncertaintyMarker
      UNIT_REFERENCE = "$unit"

      ARGUMENT_FIELDS = {
        standard: [%i[magnitude]],
        expanded: [%i[magnitude coverage_factor],
                   %i[magnitude coverage_factor coverage_probability]],
        coverage_interval: [%i[lower upper coverage_probability]],
      }.freeze

      module_function

      def names
        Math::Function::Uncertainty::MARKER_NAMES
      end

      def name_pattern
        @name_pattern ||= begin
          alternatives = names.values.map { |name| Regexp.escape(name) }
          /\A\s*(#{alternatives.join('|')})(?![\w-])/
        end
      end

      # True when the text uses one of the three concept names, whether or
      # not the rest of the marker is well formed.
      def marker?(text)
        text.is_a?(String) && name_pattern.match?(text)
      end

      # Builds the Uncertainty node described by the marker. `unit` is
      # called only when the marker refers to `$unit`, and must return the
      # unit content read from the markup.
      def build(text, &unit)
        fields = parse(text)
        options = fields[:options]
        if fields[:unit]
          unit_value = unit&.call
          invalid!(text, "it refers to $unit but no unit content was found") unless unit_value

          options[:unit] = unit_value
        end
        Math::Function::Uncertainty.new(fields[:value], **options)
      end

      def parse(text)
        match = marker_match(text)
        category = names.key(match[:name])
        arguments = match[:arguments].split(",", -1).map(&:strip)
        unit = arguments.last == UNIT_REFERENCE
        arguments.pop if unit
        if arguments.any? { |argument| argument.empty? || argument.start_with?("$") }
          invalid!(text, "arguments must be numbers, with $unit only as the last one")
        end

        value, *rest = arguments
        fields = ARGUMENT_FIELDS[category].find { |list| list.length == rest.length }
        invalid!(text, "wrong number of arguments for #{match[:name]}") unless fields

        options = { category: category }
        fields.zip(rest).each { |field, number| options[field] = Math::Number.new(number) }
        options.merge!(property_options(category, match[:property], text))
        { value: Math::Number.new(value), options: options, unit: unit }
      end

      def marker_match(text)
        name = Regexp.union(names.values)
        pattern = /\A\s*(?<name>#{name})(?::(?<property>[^():,\s]+))?\((?<arguments>[^()]*)\)\s*\z/
        pattern.match(text) || invalid!(text, "it is not of the form name[:property](arguments)")
      end

      def property_options(category, property, text)
        case category
        when :standard
          return { notation: :absolute } if property.nil?
          return { notation: :concise } if property == "concise"
        when :expanded
          return {} if property.nil?
        when :coverage_interval
          return {} if property.nil?

          kind = Math::Function::Uncertainty::INTERVAL_KIND_NAMES.key(property)
          return { interval_kind: kind } if kind
        end
        invalid!(text, "unknown property :#{property}")
      end

      def invalid!(text, detail)
        raise Errors::InvalidUncertainty.new("marker #{text.inspect}: #{detail}")
      end
    end
  end
end
