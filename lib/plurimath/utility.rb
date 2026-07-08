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
    MUNDER_CLASSES = %w[
      ubrace
      obrace
      right
      max
      min
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
    TEXT_CLASSES = %w[
      symbol
      number
      text
    ].freeze
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

      def ox_element(node, attributes: [], namespace: "")
        namespace = "#{namespace}:" unless namespace.empty?

        element = Plurimath.xml_engine.new_element("#{namespace}#{node}")
        element.set_attr(attributes)
        element
      end

      def rpr_element(wi_tag: false)
        rpr_element = ox_element("rPr", namespace: "w")
        attributes = { "w:ascii": "Cambria Math", "w:hAnsi": "Cambria Math" }
        rpr_element << ox_element(
          "rFonts",
          namespace: "w",
          attributes: attributes,
        )
        rpr_element << ox_element("i", namespace: "w") if wi_tag
        rpr_element
      end

      def update_nodes(element, nodes)
        nodes&.each do |node|
          next update_nodes(element, node) if node.is_a?(Array)

          element << node unless node.nil?
        end
        element
      end

      def pr_element(main_tag, wi_tag = false, namespace: "")
        tag_name = "#{main_tag}Pr"
        ox_element(
          tag_name,
          namespace: namespace,
        ) << rpr_element(wi_tag: wi_tag)
      end

      def filter_values(array, new_formula: true)
        return array unless array.is_a?(Array) || array.is_a?(Math::Formula)

        array = array.is_a?(Math::Formula) ? array.value : array.flatten.compact
        return Math::Formula.new(array) if array.length > 1 && new_formula
        return array if array.length > 1 && !new_formula

        array.first
      end

      def text_classes(text, lang:)
        return nil unless text

        text = filter_values(text) unless text.is_a?(String)
        return text if text.is_a?(Math::Core)

        if text&.scan(/[[:digit:]]/)&.length == text&.length
          Math::Number.new(text)
        elsif text&.match?(/[a-zA-Z]/)
          Math::Function::Text.new(text, lang: lang)
        else
          text = string_to_html_entity(text)
            .gsub("&#x26;", "&")
            .gsub("&#x3c;", "<")
            .gsub("&#x27;", "'")
            .gsub("&#xa0;", " ")
            .gsub("&#x3e;", ">")
            .gsub("&#xa;", "\n")
          symbols_class(text, lang: lang)
        end
      end

      def symbol_value(object, value)
        (object.is_a?(Math::Symbols::Comma) if value&.include?(",")) ||
          (object.is_a?(Math::Symbols::Minus) if value&.include?("-")) ||
          (object.is_a?(Math::Symbols::Paren::Vert) if value&.include?("|")) ||
          (object.is_a?(Math::Symbols::Symbol) && object&.value&.include?(value)) ||
          (value == "\\\\" && object.is_a?(Math::Function::Linebreak))
      end

      def mathml_unary_classes(text_array, omml: false, unicode_only: false,
lang: nil)
        return [] if text_array.empty?

        compacted = text_array.compact
        return filter_values(compacted) unless compacted.any?(String)

        string  = compacted.join
        classes = Mathml::Constants::CLASSES
        unicode = string_to_html_entity(string)
        return symbols_class(unicode, lang: lang) if unicode_only && unicode

        symbol = Mathml::Constants::UNICODE_SYMBOLS[unicode.strip.to_sym]
        if classes.include?(symbol&.strip)
          get_class(symbol.strip).new
        elsif classes.any?(string&.strip) && word_resolvable?(string, lang)
          get_class(string.strip).new
        elsif omml
          text_classes(string,
                       lang: lang)
        else
          symbols_class(unicode, lang: lang)
        end
      end

      # In MathML and OMML most constructs have a dedicated character or
      # structural element (<mfrac>, <m:f>, &#x2211;, <mover> + diacritic), so a
      # bare word token resolves to its function class only when the name has no
      # such representation (sin, min, log, ...). Parslet-based languages
      # (AsciiMath bar(x), LaTeX \frac{}{}) parse words in their own grammars and
      # never reach this resolver, so they keep resolving every CLASSES word.
      def word_resolvable?(string, lang)
        return true unless %i[mathml omml].include?(lang)

        Mathml::Constants.named_function_word?(string)
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

      def validate_left_right(fields = [])
        fields.each do |field|
          if field.is_a?(Math::Formula) && field.value.first.is_a?(Math::Function::Left)
            field.left_right_wrapper = true
          end
        end
      end

      def populate_function_classes(mrow = [], lang:)
        flatten_mrow = mrow.flatten.compact
        unary_function_classes(flatten_mrow, lang: lang)
        binary_function_classes(flatten_mrow, lang: lang)
        ternary_function_classes(flatten_mrow)
        flatten_mrow
      end

      def binary_function_classes(mrow, lang:, under: false)
        binary_class = Math::Function::BinaryFunction
        mrow.each_with_index do |object, ind|
          if object.is_a?(String)
            mrow[ind] =
              mathml_unary_classes([object], lang: lang)
          end
          object = mrow[ind]
          next unless object.is_a?(binary_class)

          if object.is_a?(Math::Function::Mod)
            next unless mrow.length >= 1

            object.parameter_one = mrow.delete_at(ind - 1) unless ind.zero?
            object.parameter_two = mrow.delete_at(ind)
          elsif Mathml::Constants::UNICODE_SYMBOLS.invert[object.class_name] && mrow.length > 1
            next if object.parameter_one || mrow.length > 2
            next object.parameter_one = mrow.delete_at(ind - 1) if under && ind <= 1

            object.parameter_one = mrow.delete_at(ind + 1)
          end
        end
      end

      def unary_function_classes(mrow, lang:)
        unary_class = Math::Function::UnaryFunction
        if mrow.any?(String) || mrow.any?(unary_class)
          mrow.each_with_index do |object, ind|
            if object.is_a?(String)
              mrow[ind] =
                mathml_unary_classes([object], lang: lang)
            end
            object = mrow[ind] if object.is_a?(String)
            next unless object.is_a?(unary_class)
            next if object.is_a?(Math::Function::Text)
            next if object.parameter_one || mrow[ind + 1].nil?
            next unless ind.zero?

            object.parameter_one = mrow.delete_at(ind + 1)
          end
        end
      end

      def ternary_function_classes(mrow)
        ternary_class = Math::Function::TernaryFunction
        if mrow.any?(ternary_class) && mrow.length > 1
          mrow.each_with_index do |object, ind|
            if object.is_a?(ternary_class)
              next if [Math::Function::Fenced, Math::Function::Multiscript].include?(object.class)
              next unless object.parameter_one || object.parameter_two
              next if object.parameter_three

              object.parameter_three = filter_values(mrow.delete_at(ind + 1))
            end
          end
        end
      end

      def validate_math_zone(object, lang:, intent: false, options: nil)
        return false unless object

        if object.is_a?(Math::Formula)
          filter_math_zone_values(object.value, lang: lang, intent: intent,
                                                options: options).find do |value|
            !(value.is_a?(Math::Function::Text) || value.is_a?(Math::Symbols::Symbol))
          end
        else
          !(TEXT_CLASSES.include?(object.class_name) || object.is_a?(Math::Symbols::Symbol))
        end
      end

      def filter_math_zone_values(value, lang:, intent: false, options: nil)
        return [] if value&.empty?

        new_arr = []
        temp_array = []
        skip_index = nil
        value.each_with_index do |obj, index|
          object = obj.dup
          next if index == skip_index
          if TEXT_CLASSES.include?(object.class_name) || math_display_text_objects(object)
            next temp_array << (if object.is_a?(Math::Symbols::Symbol)
                                  symbol_to_text(
                                    object, lang: lang, intent: intent, options: options
                                  )
                                else
                                  object.value
                                end)
          end

          if temp_array.any?
            new_arr << Math::Function::Text.new(temp_array.join(" "),
                                                lang: lang)
          end
          temp_array = []
          new_arr << object
        end
        if temp_array.any?
          new_arr << Math::Function::Text.new(temp_array.join(" "),
                                              lang: lang)
        end
        new_arr
      end

      def symbol_to_text(symbol, lang:, options:, intent: false)
        case lang
        when :asciimath
          symbol.to_asciimath(options: options)
        when :latex
          symbol.to_latex(options: options)
        when :mathml
          symbol.to_mathml_without_math_tag(intent,
                                            options: options).nodes.first
        when :omml
          symbol.to_omml_without_math_tag(true, options: options)
        when :unicodemath
          symbol.to_unicodemath(options: options)
        end
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

      def notations_to_mask(notations)
        mask = notations.split.map do |notation|
          MASK_CLASSES.key(notation)
        end
        mask.inject(*:+) ^ 15
      end

      def math_display_text_objects(object)
        class_names = ["plus", "minus", "circ", "equal", "symbol"].freeze
        class_names.include?(object.class_name)
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
