# frozen_string_literal: true

module Plurimath
  class Cli < Thor
    # Shared behavior for CLI command objects (Cli::Convert, Cli::Render):
    # holds the parsed Thor +options+ and the helpers both commands need.
    module Helpers
      attr_reader :options

      def initialize(options)
        super()
        @options = options
      end

      # Resolve the raw input string from either --file-path or --input.
      def input_string
        options[:file_path] ? File.read(options[:file_path]) : options[:input]
      end

      def configure_xml_engine(input_format, output_format)
        xml_formats = %w[mathml omml]
        return unless xml_formats.include?(input_format) || xml_formats.include?(output_format)

        set_xml_engine(options[:xml_engine] || "ox")
      end

      def set_xml_engine(engine)
        engine_class = case engine
                       when "ox"
                         require_relative "../setup/ox_engine"
                         Plurimath::XmlEngine::OxEngine
                       when "oga"
                         require_relative "../setup/oga"
                         Plurimath::XmlEngine::Oga
                       else
                         warn_and_exit("Invalid XML engine: #{engine}. Use 'ox' or 'oga'.")
                       end
        Plurimath.xml_engine = engine_class
      end

      # Print a message and exit non-zero. Uses exit(1) rather than abort so a
      # rescued exception is not re-printed as a SystemExit cause backtrace.
      def warn_and_exit(message)
        warn(message)
        exit(1)
      end
    end
  end
end
