# frozen_string_literal: true

module Plurimath
  class Utility
    autoload :IntentEncoding, "#{__dir__}/utility/intent_encoding"
    UNICODE_REGEX = %r{&#x[a-zA-Z0-9]+;}
    FONT_STYLES = {
      "double-struck": Math::Function::FontStyle::DoubleStruck,
      "sans-serif-bold-italic": Math::Function::FontStyle::SansSerifBoldItalic,
      "sans-serif-italic": Math::Function::FontStyle::SansSerifItalic,
      "bold-sans-serif": Math::Function::FontStyle::BoldSansSerif,
      "sans-serif": Math::Function::FontStyle::SansSerif,
      "bold-fraktur": Math::Function::FontStyle::BoldFraktur,
      "bold-italic": Math::Function::FontStyle::BoldItalic,
      "bold-script": Math::Function::FontStyle::BoldScript,
      mbfitsans: Math::Function::FontStyle::SansSerifBoldItalic,
      monospace: Math::Function::FontStyle::Monospace,
      mathfrak: Math::Function::FontStyle::Fraktur,
      mitsans: Math::Function::FontStyle::SansSerifItalic,
      mbfsans: Math::Function::FontStyle::BoldSansSerif,
      mbffrak: Math::Function::FontStyle::BoldFraktur,
      mathcal: Math::Function::FontStyle::Script,
      fraktur: Math::Function::FontStyle::Fraktur,
      mbfscr: Math::Function::FontStyle::BoldScript,
      mathbb: Math::Function::FontStyle::DoubleStruck,
      double: Math::Function::FontStyle::DoubleStruck,
      mathtt: Math::Function::FontStyle::Monospace,
      mathsf: Math::Function::FontStyle::SansSerif,
      mathrm: Math::Function::FontStyle::Normal,
      textrm: Math::Function::FontStyle::Normal,
      italic: Math::Function::FontStyle::Italic,
      mathit: Math::Function::FontStyle::Italic,
      textit: Math::Function::FontStyle::Italic,
      mathbf: Math::Function::FontStyle::Bold,
      textbf: Math::Function::FontStyle::Bold,
      script: Math::Function::FontStyle::Script,
      normal: Math::Function::FontStyle::Normal,
      mbfit: Math::Function::FontStyle::BoldItalic,
      msans: Math::Function::FontStyle::SansSerif,
      mfrak: Math::Function::FontStyle::Fraktur,
      mscr: Math::Function::FontStyle::Script,
      bold: Math::Function::FontStyle::Bold,
      bbb: Math::Function::FontStyle::DoubleStruck,
      Bbb: Math::Function::FontStyle::DoubleStruck,
      mtt: Math::Function::FontStyle::Monospace,
      cal: Math::Function::FontStyle::Script,
      mit: Math::Function::FontStyle::Italic,
      mup: Math::Function::FontStyle::Normal,
      mbf: Math::Function::FontStyle::Bold,
      sf: Math::Function::FontStyle::SansSerif,
      tt: Math::Function::FontStyle::Monospace,
      fr: Math::Function::FontStyle::Fraktur,
      rm: Math::Function::FontStyle::Normal,
      cc: Math::Function::FontStyle::Script,
      ii: Math::Function::FontStyle::Italic,
      bb: Math::Function::FontStyle::Bold,
      bf: Math::Function::FontStyle::Bold,
    }.freeze
    ALIGNMENT_LETTERS = {
      c: "center",
      r: "right",
      l: "left",
    }.freeze
    UNARY_CLASSES = %w[
      arccos
      arcsin
      arctan
      liminf
      limsup
      right
      sech
      sinh
      tanh
      cosh
      coth
      csch
      left
      max
      min
      sec
      sin
      sup
      deg
      det
      dim
      exp
      gcd
      glb
      lub
      lcm
      ker
      tan
      cos
      cot
      csc
      ln
      lg
    ].freeze
    PARENTHESIS = {
      "&#x2329;": "&#x232a;",
      "&#x230a;": "&#x230b;",
      "&#x2308;": "&#x2309;",
      "&#x2016;": "&#x2016;",
      "&#x7b;": "&#x7d;",
      "&#x5b;": "&#x5d;",
      "&#x7c;": "&#x7c;",
      "(": ")",
      "{": "}",
      "[": "]",
    }.freeze
    UNICODEMATH_MENCLOSE_FUNCTIONS = {
      underline: "bottom",
      underbar: "bottom",
      longdiv: "longdiv",
      xcancel: "updiagonalstrike downdiagonalstrike",
      bcancel: "updiagonalstrike",
      ellipse: "circle",
      circle: "circle",
      cancel: "downdiagonalstrike",
      rrect: "roundedbox",
      rect: "box",
    }.freeze
    MASK_CLASSES = {
      1 => "top",
      2 => "bottom",
      4 => "left",
      8 => "right",
      16 => "horizontalstrike",
      32 => "verticalstrike",
      64 => "downdiagonalstrike",
      128 => "updiagonalstrike",
    }.freeze

    class << self
      def get_table_class(text)
        Object.const_get("Plurimath::Math::Function::Table::#{capitalize(text)}")
      end

      def get_class(text)
        Object.const_get("Plurimath::Math::Function::#{capitalize(text)}")
      end

      def capitalize(text)
        text.to_s.split("_").map(&:capitalize).join
      end

      def paren_files
        Math::Symbols::Paren.descendants
      end

      def symbols_files
        Math::Symbols::Symbol.descendants
      end

      def symbols_hash(lang)
        @@symbols ||= {}
        lang_symbols = @@symbols[lang]
        return lang_symbols if lang_symbols && !lang_symbols.empty?

        lang_symbols = {}
        symbols_files.map do |class_object|
          class_object::INPUT[lang]&.flatten&.each do |symbol|
            next if lang_symbols.key?(symbol)

            lang_symbols[symbol] = class_object
          end
        end
        @@symbols[lang] = lang_symbols.sort_by { |v, _| -v.length }.to_h
      end

      def parens_hash(lang, skipables: nil)
        @@parens ||= {}
        lang_parens = @@parens[lang]
        return lang_parens if lang_parens && !lang_parens.empty?

        lang_parens = {}
        paren_files.map do |class_object|
          class_object::INPUT[lang]&.flatten&.each do |symbol|
            next if skipables&.include?(class_object.new.class_name)
            next if lang_parens.key?(symbol)

            lang_parens[symbol] = class_object
          end
        end
        @@parens[lang] = lang_parens.sort_by { |v, _| -v.length }.to_h
      end

      def all_symbols_classes(lang)
        symbols_hash(lang).merge(parens_hash(lang))
      end

      def filter_values(array, new_formula: true)
        return array unless array.is_a?(Array) || array.is_a?(Math::Formula)

        array = array.is_a?(Math::Formula) ? array.value : array.flatten.compact
        return Math::Formula.new(array) if array.length > 1 && new_formula
        return array if array.length > 1 && !new_formula

        array.first
      end

      def symbol_value(object, value)
        return false if value.nil?

        (object.is_a?(Math::Symbols::Comma) if value == ",") ||
          (object.is_a?(Math::Symbols::Minus) if value == "-") ||
          (object.is_a?(Math::Symbols::Paren::Vert) if value == "|") ||
          (object.is_a?(Math::Symbols::Symbol) && object&.value == value) ||
          (value == "\\\\" && object.is_a?(Math::Function::Linebreak))
      end

      def symbols_class(string, lang:, table: false)
        return string unless string.is_a?(String) || string.is_a?(Parslet::Slice)
        return latex_table_curly_paren(string) if table && lang == :latex

        all_symbols_classes(lang)[string.to_s.strip]&.new ||
          Math::Symbols::Symbol.new(string)
      end

      def string_to_html_entity(string)
        HTML_ENTITIES.encode(
          string.frozen? ? string : string.force_encoding("UTF-8"),
          :hexadecimal,
        )
      end

      HTML_ENTITIES = HTMLEntities.new

      def html_entity_to_unicode(string)
        return string unless string&.include?("&")

        HTML_ENTITIES.decode(string)
      end

      def table_separator(separator, value, symbol: "solid")
        sep_symbol = Math::Function::Td.new([Math::Symbols::Paren::Vert.new])
        separator&.each_with_index do |sep, ind|
          next unless sep == symbol

          value.map do |val|
            val.parameter_one.insert(ind + 1, sep_symbol) if symbol == "solid"
            val.parameter_one.insert(ind, sep_symbol) if symbol == "|"
            begin
              (val.parameter_one[val.parameter_one.index(nil)] =
                 Math::Function::Td.new([]))
            rescue StandardError
              nil
            end
            val
          end
        end
        value
      end

      def unfenced_value(object, paren_specific: false)
        case object
        when Math::Function::Fenced
          if !paren_specific || (paren_specific && valid_paren?(object))
            filter_values(object.parameter_two)
          else
            object
          end
        when Array
          filter_values(object)
        else
          object
        end
      end

      def valid_paren?(object)
        object.parameter_one.is_a?(Math::Symbols::Paren::Lround) &&
          object.parameter_three.is_a?(Math::Symbols::Paren::Rround) &&
          object.options.keys.none? do |k|
            %i[open_paren close_paren].any?(k.to_sym)
          end &&
          !object.parameter_one.mini_sup_sized &&
          !object.parameter_three.mini_sub_sized &&
          object.options.empty?
      end

      def symbol_object(value, lang: nil)
        value = case value
                when "ℒ" then "{:"
                when "ℛ" then ":}"
                when "ᑕ" then "&#x2329;"
                when "ᑐ" then "&#x232a;"
                else value
                end
        symbols_class(value, lang: lang)
      end

      def primes_constants
        primes = {}
        primes
          .merge!(UnicodeMath::Constants::PREFIXED_PRIMES)
          .merge({ sprime: "&#x27;" })
      end

      def hexcode_in_input(field)
        field.input(:unicodemath)&.flatten&.find do |input|
          input.match?(/&#x.+;/)
        end
      end

      def latex_table_curly_paren(string)
        case string
        when "{" then Math::Symbols::Paren::Lcurly.new
        when "}" then Math::Symbols::Paren::Rcurly.new
        else symbols_class(string, lang: :latex)
        end
      end
    end
  end
end
