# frozen_string_literal: true

module Plurimath
  class UnicodeMath
    class Parser
      attr_accessor :text

      # umath is a runtime dependency; this line is only guidance for
      # installs where the gem is unexpectedly missing.
      UMATH_GEMFILE_LINE = 'gem "umath"'

      # A \u escape of one to five hexadecimal digits. umath turns it into
      # a character reference with the digits as written, which its symbol
      # table knows only without leading zeros, and drops up to five letters
      # or digits after it. A \u that follows a backslash is left to umath.
      U_ESCAPE = /(?<!\\)\\u([\da-fA-F]{1,5})/
      # Characters whose escape stays with umath: its comment brackets would
      # act as brackets once written out.
      U_ESCAPE_KEPT = [0x2af7, 0x2af8].freeze
      SURROGATES = (0xd800..0xdfff)

      LABELED_TR_REGEX = /"([^"]*(#|&#x23;|\\\\eqno)[^"]*[^"]*|[^"]*(#|&#x23;|\\\\eqno)[^"]*[^"]*)"/

      def initialize(text)
        @input = text
        text = pre_processing(text)
        @text = ::HTMLEntities.new.encode(text, :hexadecimal)
        @text = @text.gsub("&#x26;", "&")
        @text = @text.gsub("&#x22;", "\"")
        @text = @text.gsub(/&#x2af7;.*&#x2af8;/, "")
        @text = @text.gsub("\\\\", "\\")
        @text = # Converting \u#{xxxx} encoding to &#x#{xxxx};
          @text.gsub(/\\u([\da-fA-F]{1,5})\w{0,5}/) do
            "&#x#{$1};"
          end
        @text = @text.strip
      end

      # The umath gem parses the input (it runs the same preprocessing
      # as #text) into its typed model, which Mapper turns into a capture
      # tree for the rule table. A grammar refusal raises
      # Parsanol::ParseFailed.
      def parse
        self.class.load_umath
        tree = parse_with_umath
        tree = post_processing(tree) if @splitted
        Math::Formula.new(
          Array(
            Mapper::Rules.new.apply(tree),
          ),
        )
      end

      class << self
        # Loaded here, outside the methods that rescue ::Umath::...
        # errors, so those clauses are never evaluated while Umath is
        # undefined.
        def load_umath
          require "umath"
        rescue LoadError => e
          raise unless e.path == "umath" || e.message.end_with?("-- umath")

          raise Math::MissingDependencyError.new(
            :unicode,
            format_name: "UnicodeMath",
            gem_name: "umath",
            gemfile_line: UMATH_GEMFILE_LINE,
          ), cause: nil
        end

        # The Parsanol::ParseFailed for a umath refusal (+error+), with
        # its cause at the reported position in +text+.
        def parse_failed(error, text)
          message = error.message
          source = Parsanol::Source.new(error.input || text)
          cause = Parsanol::Cause.new(message, source, error.byte_offset || 0, [])
          Parsanol::ParseFailed.new(message, cause)
        end
      end

      private

      def parse_with_umath
        document = ::Umath.parse(expand_escapes(@input), decimal: Plurimath.configuration.decimal)
        Mapper.new.call(document)
      rescue ::Umath::ParseError => e
        raise self.class.parse_failed(e, text)
      end

      # Writes each \u escape of a non-ASCII character as the character
      # itself, so that umath reads it like the character typed in: `\u03B1x`
      # is α followed by x. An ASCII escape, a comment bracket and a value
      # that is not a character stay for umath.
      def expand_escapes(text)
        text.gsub(U_ESCAPE) do |escape|
          code = ::Regexp.last_match(1).hex
          if code < 0x80 || U_ESCAPE_KEPT.include?(code) || SURROGATES.cover?(code)
            escape
          else
            [code].pack("U")
          end
        end
      end

      def post_processing(tree)
        {
          labeled_tr_value: tree,
          labeled_tr_id: @splitted,
        }
      end

      def pre_processing(text)
        text unless text.include?("#") && !text.match?(LABELED_TR_REGEX)

        text = text.gsub(/✎\(.*(\#).*\)/) do |str|
          str.gsub("#", "\"replacement\"")
        end
        splitted = text.split("#")
        splitted[0] = splitted.first.gsub("\"replacement\"", "#")
        @splitted = splitted.last if splitted.count > 1
        splitted.first
      end
    end
  end
end
