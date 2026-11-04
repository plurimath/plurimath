# frozen_string_literal: true

module Plurimath
  class Latex
    class Parser
      attr_accessor :text

      TEXT_REGEX = %r(\\(?:mbox|text)\{[^}]+\})

      # latexmath is a runtime dependency; this line is only guidance for
      # installs where the gem is unexpectedly missing.
      LATEXMATH_GEMFILE_LINE = 'gem "latexmath"'

      def initialize(text)
        @enti = ::HTMLEntities.new
        @input = text
        @text = pre_processing(text)
      end

      # The latexmath gem parses the input (it runs the same preprocessing
      # as #text) into its typed model, which Mapper turns into a Formula.
      # A grammar refusal raises Parsanol::ParseFailed at the position the
      # grammar reports in #text.
      def parse
        self.class.load_latexmath
        parse_with_latexmath
      end

      class << self
        # Loaded here, outside the methods that rescue ::Latexmath::...
        # errors, so those clauses are never evaluated while Latexmath is
        # undefined.
        def load_latexmath
          require "latexmath"
        rescue LoadError => e
          raise unless e.path == "latexmath" || e.message.end_with?("-- latexmath")

          raise Math::MissingDependencyError.new(
            :latex,
            format_name: "LaTeX",
            gem_name: "latexmath",
            gemfile_line: LATEXMATH_GEMFILE_LINE,
          ), cause: nil
        end

        # The Parsanol::ParseFailed for a latexmath refusal (+error+), or for
        # input without a formula (+error+ nil, grammar input +text+), with
        # its cause at the grammar's position.
        def parse_failed(error, text)
          message = error&.message || "LaTeX input has no formula"
          source = Parsanol::Source.new(error&.grammar_input || text)
          cause = Parsanol::Cause.new(message, source, error&.grammar_byte_offset || 0, [])
          Parsanol::ParseFailed.new(message, cause)
        end
      end

      private

      def parse_with_latexmath
        document = ::Latexmath.parse(@input, decimal: Plurimath.configuration.decimal)
        # Input without a formula (empty, or only spaces and newlines) is a
        # refusal at its start, as the grammar reports it.
        raise self.class.parse_failed(nil, text) if document.expression.nil?

        Mapper.new.call(document)
      rescue ::Latexmath::ParseError => e
        raise self.class.parse_failed(e, text)
      end

      def pre_processing(text)
        text_functions = text.scan(TEXT_REGEX)
        text = @enti.encode(@enti.decode(text), :hexadecimal)
        text = gsub_space_and_unicodes(text)
        text.gsub(TEXT_REGEX) { |_str| text_functions.shift }
      end

      def gsub_space_and_unicodes(text)
        text
          .gsub(/((?<!\\) )|\n+/, "")
          .gsub("\\\\ ", "\\\\\\\\")
          .gsub("&#x26;", "&")
          .gsub("&#x22;", "\"")
          .gsub(/(?<!\\\\)\\&#xa;/, "\\ ")
          .gsub("&#xa;", "")
      end
    end
  end
end
