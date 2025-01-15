# frozen_string_literal: true

require_relative "utility/intent_encoding"
require_relative "utility/shared"
module Plurimath
  class Utility
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

    extend Shared

    class << self
      def get_table_class(text)
        Object.const_get("Plurimath::Math::Function::Table::#{capitalize(text)}")
      end

      def sub_sup_method?(sub_sup)
        if sub_sup.methods.include?(:class_name)
          Html::Constants::SUB_SUP_CLASSES.value?(sub_sup.class_name.to_sym)
        end
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

      def nil_to_none_object(value)
        return value unless value.any?(NilClass) || value.any? { |val| val.is_a?(Array) && val.empty? }

        value.each_with_index do |val, index|
          next unless val.nil? || val.is_a?(Array)

          value[index] = Math::Function::None.new
        end
      end

      def symbols_hash(lang)
        @@symbols ||= {}
        return @@symbols[lang] if @@symbols[lang]&.any?

        lang_symbols = {}
        symbols_files.each do |class_object|
          class_object::INPUT[lang]&.flatten&.each do |symbol|
            lang_symbols[symbol] ||= class_object
          end
        end
        @@symbols[lang] = lang_symbols.sort_by { |v, _| -v.length }.to_h
      end

      def parens_hash(lang, skipables: nil)
        @@parens ||= {}
        return @@parens[lang] if @@parens[lang]&.any?

        lang_parens = {}
        paren_files.each do |class_object|
          next if skipables&.include?(class_object.class_name)

          class_object::INPUT[lang]&.flatten&.each do |symbol|
            lang_parens[symbol] ||= class_object
          end
        end
        @@parens[lang] = lang_parens.sort_by { |v, _| -v.length }.to_h
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

      # TODO: move to new OMML helper classes
      def nary_fonts(nary, lang:)
        narypr  = nary.first.flatten.compact
        subsup  = narypr.any?("undOvr") ? "undOvr" : "subSup"
        unicode = narypr.any?(Hash) ? narypr.first[:chr] : "∫"
        Math::Function::Nary.new(
          symbols_class(string_to_html_entity(unicode), lang: lang),
          filter_values(nary[1]),
          filter_values(nary[2]),
          filter_values(nary[3]),
          { type: subsup }
        )
      end

      # TODO: move to new OMML helper classes
      def find_pos_chr(fonts_array, key)
        fonts_array.find { |d| d.is_a?(Hash) && d[key] }
      end

      def symbol_value(object, value)
        (object.is_a?(Math::Symbols::Comma) if value&.include?(",")) ||
          (object.is_a?(Math::Symbols::Minus) if value&.include?("-")) ||
          (object.is_a?(Math::Symbols::Paren::Vert) if value&.include?("|")) ||
          (object.is_a?(Math::Symbols::Symbol) && object&.value&.include?(value)) ||
          (value == "\\\\" && object.is_a?(Math::Function::Linebreak))
      end

      def symbols_class(string, lang:, table: false)
        return string unless string.is_a?(String) || string.is_a?(Parslet::Slice)
        return latex_table_curly_paren(string) if table && lang == :latex

        all_symbols_classes(lang)[string.to_s.strip]&.new ||
          Math::Symbols::Symbol.new(string)
      end

      def all_symbols_classes(lang)
        symbols_hash(lang).merge(parens_hash(lang))
      end

      def html_entity_to_unicode(string)
        entities = HTMLEntities.new
        entities.decode(string)
      end

      # TODO: move to new OMML helper classes
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

      # TODO: move to new OMML helper classes
      def valid_class(object)
        text = object.extract_class_name_from_text
        (object.extractable? && Plurimath::Asciimath::Constants::SUB_SUP_CLASSES.include?(text)) ||
          Plurimath::Latex::Constants::SYMBOLS[text.to_sym] == :power_base
      end

      def hexcode_in_input(field)
        field.input(:unicodemath)&.flatten&.find { |input| input.match?(/&#x.+;/) }
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
