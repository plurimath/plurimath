# frozen_string_literal: true

module Plurimath
  module Math
    class ParseOptionError < Plurimath::Error
      def self.unknown_options(options, supported_options:)
        new(
          "unknown parse #{option_label(options)}: #{format_options(options)}; " \
          "supported parse options are #{format_options(supported_options)}",
        )
      end

      def self.unsupported_options(type, options, supported_types:)
        new(
          "parse #{option_label(options)} #{format_options(options)} " \
          "#{be_verb(options)} not supported for #{type.inspect}; " \
          "supported input types are #{format_options(supported_types)}",
        )
      end

      def self.option_label(options)
        options.one? ? "option" : "options"
      end

      def self.be_verb(options)
        options.one? ? "is" : "are"
      end

      def self.format_options(options)
        options.map(&:inspect).join(", ")
      end
    end
  end
end
