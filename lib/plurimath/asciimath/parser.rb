# frozen_string_literal: true

module Plurimath
  class Asciimath
    class Parser
      # An uncertainty call. amath splits letters, so xustd(1,5) is x
      # followed by ustd(1,5): a preceding letter does not exempt it.
      UNCERTAINTY_CALL = /u(?:std|exp|cov)\(/

      attr_accessor :text, :dialect

      # pma text goes to amath unchanged; the substitutions below are
      # dialect L spellings only.
      def initialize(text, dialect: :legacy)
        @dialect = dialect
        @text = dialect == :pma ? text : legacy_text(text)
      end

      def legacy_text(text)
        text
          &.gsub(/(\|:|:\|)/, "|")
          &.gsub(/(\{:)/, "ℒ")
          &.gsub(/(:\})/, "ℛ")
          &.gsub(/(\(:)/, "ᑕ")
          &.gsub(/(:\))/, "ᑐ")
      end
      private :legacy_text

      # The amath gem parses #text (dialect L, the Ruby engine) into its
      # typed model, which Mapper turns into a Formula. A grammar refusal
      # raises Parslet::ParseFailed at the position amath reports in #text.
      def parse
        ambiguous_uncertainty_comma! unless dialect == :pma
        Parse.new.load_amath
        parse_with_amath
      end

      private

      # pma numbers always use the full stop, whatever the locale.
      def parse_with_amath
        decimal = dialect == :pma ? "." : Plurimath.configuration.decimal
        document = ::Amath.parse_model(text, dialect: dialect, engine: :ruby,
                                             decimal: decimal)
        Mapper.new.call(document, text)
      rescue ::Amath::ParseError => e
        raise Parse.parse_failed(e, text)
      end

      # Uncertainty arguments use "." as the decimal mark and "," between
      # arguments. Under a locale whose decimal mark is not ".", a separator
      # comma directly followed by a digit (ustd(1,5), uexp(10,0, 0,3, 2))
      # most likely is a decimal comma: amath would read it as a separator,
      # or give up on the call and read letters (ustd(1,230, 0,004) under fr).
      # Raise instead of guessing; other input is not checked.
      def ambiguous_uncertainty_comma!
        decimal = Plurimath.configuration.decimal
        return if decimal == "." || text.nil?

        text.to_enum(:scan, UNCERTAINTY_CALL).each do
          start = Regexp.last_match.begin(0)
          next if text[0...start].count('"').odd?

          call = uncertainty_call(start, Regexp.last_match.end(0))
          next unless call

          raise Math::AmbiguousDecimalError.new(
            "uncertainty forms use '.' as the decimal mark; the comma " \
            "before a digit in #{call} is ambiguous with decimal " \
            "'#{decimal}' (locale #{Plurimath.configuration.locale}), " \
            "write the value with '.' and separate arguments with ', '",
          )
        end
      end

      # The call text from start to its closing parenthesis if a top-level
      # argument separator in it is directly followed by a digit, else nil.
      def uncertainty_call(start, index)
        depth = 1
        quoted = false
        ambiguous = false
        while index < text.length && depth.positive?
          char = text[index]
          quoted = !quoted if char == '"'
          unless quoted
            depth += 1 if char == "("
            depth -= 1 if char == ")"
            ambiguous ||= depth == 1 && char == "," &&
              text[index + 1].to_s.match?(/\A[0-9]\z/)
          end
          index += 1
        end
        text[start...index] if ambiguous
      end
    end
  end
end
