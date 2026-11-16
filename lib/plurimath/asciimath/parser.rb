# frozen_string_literal: true

module Plurimath
  class Asciimath
    class Parser
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
    end
  end
end
