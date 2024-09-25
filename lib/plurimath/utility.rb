# frozen_string_literal: true

require_relative "utility/intent_encoding"
require_relative "utility/shared"
module Plurimath
  class Utility
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
    TABLE_SUPPORTED_ATTRS = %i[
      columnlines
      rowlines
      frame
    ].freeze
    MPADDED_ATTRS = %i[
      height
      depth
      width
    ].freeze
    MGLYPH_ATTRS = %i[
      height
      width
      index
      alt
      src
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
      1 => 'top',
      2 => 'bottom',
      4 => 'left',
      8 => 'right',
      16 => 'horizontalstrike',
      32 => 'verticalstrike',
      64 => 'downdiagonalstrike',
      128 => 'updiagonalstrike'
    }.freeze

    extend Shared

    class << self

      def organize_table(array, column_align: nil, options: nil)
        table = []
        table_data = []
        table_row = []
        organize_options(array, column_align) if options
        string_columns = column_align&.map { |column| column.is_a?(Math::Symbols::Paren) ? "|" : column.value }
        array.each do |data|
          if data&.separate_table
            table_row << Math::Function::Td.new(filter_table_data(table_data).compact)
            table_data = []
            if data.linebreak?
              organize_tds(table_row.flatten, string_columns.dup, options)
              table << Math::Function::Tr.new(table_row)
              table_row = []
            end
            next
          end
          table_data << data
        end
        table_row << Math::Function::Td.new(table_data.compact) if table_data
        unless table_row.nil? || table_row.empty?
          organize_tds(table_row.flatten, string_columns.dup, options)
          table << Math::Function::Tr.new(table_row)
        end
        table_separator(string_columns, table, symbol: "|") unless column_align.nil? || column_align.empty?
        table
      end

      def organize_options(table_data, column_align)
        return column_align if column_align.length <= 1

        align = [column_align&.shift]
        table_data.insert(0, *column_align)
        align
      end

      def table_options(table_data)
        rowline = ""
        table_data.each do |tr|
          if tr&.parameter_one&.first&.parameter_one&.first.is_a?(Math::Symbols::Hline)
            rowline += "solid "
          else
            rowline += "none "
          end
        end
        options = { rowline: rowline.strip } if rowline.include?("solid")
        options || {}
      end

      def organize_tds(tr_array, column_align, options)
        return tr_array if column_align.nil? || column_align.empty?

        column_align.reject! { |string| string == "|" }
        column_align = column_align * tr_array.length if options
        tr_array.each_with_index do |td, ind|
          columnalign = ALIGNMENT_LETTERS[column_align[ind]&.to_sym]
          td.parameter_two = { columnalign: columnalign } if columnalign
        end
      end

      def filter_table_data(table_data)
        table_data.each_with_index do |object, ind|
          if object.is_a?(Math::Symbols::Minus)
            table_data[ind] = Math::Formula.new(
              [object, table_data.delete_at(ind.next)],
            )
          end
        end
        table_data
      end

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

      def symbols_hash(lang)
        initialize_class_variable(:"@@symbols")
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
        initialize_class_variable(:"@@parens")
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

      def initialize_class_variable(var_name, var_value = {})
        return if class_variable_defined?(var_name)

        class_variable_set(var_name, var_value)
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
          Math::Function::Text.new(text)
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

      def html_entity_to_unicode(string)
        entities = HTMLEntities.new
        entities.decode(string)
      end

<<<<<<< HEAD
      def join_attr_value(attrs, value, unicode_only: false, lang: :mathml)
        if attrs&.is_a?(Hash) && attrs.key?(:intent)
          [
            Math::Function::Intent.new(
              filter_values(join_attr_value(nil, value, unicode_only: unicode_only, lang: lang)),
              Math::Function::Text.new(attrs[:intent]),
            )
          ]
        elsif value.any?(String)
          new_value = mathml_unary_classes(value, unicode_only: unicode_only, lang: lang)
          array_value = Array(new_value)
          attrs.nil? ? array_value : join_attr_value(attrs, array_value, unicode_only: unicode_only)
        elsif attrs.nil?
          value
        elsif attrs.is_a?(String) && ["solid", "none"].include?(attrs.split.first.downcase)
          table_separator(attrs.split, value)
        elsif attrs.is_a?(Hash)
          if (attrs.key?(:accent) || attrs.key?(:accentunder))
            attr_is_accent(attrs, value)
          elsif attrs.key?(:linebreak)
            Math::Function::Linebreak.new(value.first, attrs)
          elsif attrs.key?(:bevelled) || attrs.key?(:linethickness)
            Math::Function::Frac.new(value[0], value[1], attrs)
          elsif attrs.key?(:notation)
            value << attrs
          elsif attrs.key?(:separators)
            fenced = Math::Function::Fenced.new(
              symbol_object(attrs[:open] || "(", lang: lang),
              value,
              symbol_object(attrs[:close] || ")", lang: lang),
            )
            fenced.options = { separators: attrs[:separators] }
            fenced
          elsif TABLE_SUPPORTED_ATTRS.any? { |atr| attrs.key?(atr) }
            Math::Function::Table.new(value, nil, nil, attrs)
          elsif MPADDED_ATTRS.any? { |atr| attrs.key?(atr) }
            Math::Function::Mpadded.new(
              filter_values(value),
              attrs,
            )
          elsif MGLYPH_ATTRS.any? { |atr| attrs.key?(atr) }
            Math::Function::Mglyph.new(
              attrs,
            )
          end
        elsif attrs.is_a?(Math::Core)
          attr_is_function(attrs, value)
        end
      end

      def attr_is_accent(attrs, value)
        if value.last.is_a?(Math::Function::UnaryFunction)
          value.last.parameter_one = value.shift if value.length > 1
          value.last.attributes = attrs.transform_values { |v| YAML.safe_load(v) }
        end
        value
      end

      def attr_is_function(attrs, value)
        case attrs
        when Math::Function::Fenced
          attrs.parameter_two = value.compact
          attrs
        when Math::Function::FontStyle
          attrs.parameter_one = filter_values(value)
          attrs
        when Math::Function::Color
          color_value = filter_values(value)
          if attrs.parameter_two
            attrs.parameter_two.parameter_one = color_value
          else
            attrs.parameter_two = color_value
          end
          attrs
        end
      end

      def nil_to_none_object(value)
        return value unless value.any?(NilClass) || value.any? { |val| val.is_a?(Array) && val.empty? }

        value.each_with_index do |val, index|
          next unless val.nil? || val.is_a?(Array)

          value[index] = Math::Function::None.new
        end
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
          !object.options.keys.any? { |k| [:open_paren, :close_paren].any?(k.to_sym) } &&
          !object.parameter_one.mini_sup_sized &&
          !object.parameter_three.mini_sub_sized &&
          object.options.empty?
      end

      def table_td(object)
        new_object = case object
                     when Math::Function::Td
                       object
                     else
                       Math::Function::Td.new([object])
                     end
        Array(new_object)
      end

=======
>>>>>>> ed31ec02 (Updated module structure and moved code in the helper files relevant to language directory)
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

      # TODO: move to new Function classes
      def validate_left_right(fields = [])
        fields.each do |field|
          if field.is_a?(Math::Formula) && field.value.first.is_a?(Math::Function::Left)
            field.left_right_wrapper = true
          end
        end
      end

      # TODO: move to new OMML helper classes
      def valid_class(object)
        text = object.extract_class_name_from_text
        (object.extractable? && Plurimath::Asciimath::Constants::SUB_SUP_CLASSES.include?(text)) ||
          Plurimath::Latex::Constants::SYMBOLS[text.to_sym] == :power_base
      end
      # Core file function
      def filter_math_zone_values(value, lang:, intent: false, options: nil)
        return [] if value&.empty?

        new_arr = []
        temp_array = []
        skip_index = nil
        value.each_with_index do |obj, index|
          object = obj.dup
          next if index == skip_index
          if TEXT_CLASSES.include?(object.class_name) || math_display_text_objects(object)
            next temp_array << (object.is_a?(Math::Symbols::Symbol) ? symbol_to_text(object, lang: lang, intent: intent, options: options) : object.value)
          end

          new_arr << Math::Function::Text.new(temp_array.join(" ")) if temp_array.any?
          temp_array = []
          new_arr << object
        end
        new_arr << Math::Function::Text.new(temp_array.join(" ")) if temp_array.any?
        new_arr
      end

      # Core file function
      def symbol_to_text(symbol, lang:, intent: false, options:)
        case lang
        when :asciimath
          symbol.to_asciimath(options: options)
        when :latex
          symbol.to_latex(options: options)
        when :mathml
          symbol.to_mathml_without_math_tag(intent, options: options).nodes.first
        when :omml
          symbol.to_omml_without_math_tag(true, options: options)
        when :unicodemath
          symbol.to_unicodemath(options: options)
        end
      end

      def hexcode_in_input(field)
        field.input(:unicodemath)&.flatten&.find { |input| input.match?(/&#x.+;/) }
      end

      def base_is_sub_or_sup?(base)
        if base.is_a?(Math::Formula)
          base_is_sub_or_sup?(base.value.first)
        elsif base.is_a?(Math::Function::Fenced)
          base_is_sub_or_sup?(base.parameter_two.first)
        elsif base.is_a?(Math::Symbols::Symbol) || base.is_a?(Math::Number)
          base.mini_sub_sized || base_mini_sup_sized
        end
      end

      def identity_matrix(size)
        matrix = Array.new(size) { Array.new(size, 0) }
        size.times { |i| matrix[i][i] = 1 }
        matrix.map do |tr|
          tr.each_with_index do |td, i|
            tr[i] = Math::Function::Td.new([Math::Number.new(td.to_s)])
          end
          Math::Function::Tr.new(tr)
        end
      end

      def enclosure_attrs(mask)
        raise "enclosure mask is not between 0 and 255" if (mask.nil? || mask < 0 || mask > 255)

        ret = ""
        unless mask.nil?
          mask ^= 15
          bin_mask = mask.to_s(2).reverse
          classes = bin_mask.chars.each_with_index.map { |bit, i| MASK_CLASSES[2**i] if bit == '1' }.compact
          ret = classes.join(' ')
        end
        ret
      end

      def notations_to_mask(notations)
        mask = []
        notations.split(" ").each { |notation| mask << MASK_CLASSES.key(notation) }
        mask.inject(*:+)^15
      end

      def slashed_values(value)
        decoded = HTMLEntities.new.decode(value)
        if decoded.to_s.match?(/^\w+/)
          Math::Function::Text.new("\\#{decoded}")
        else
          Math::Symbols::Symbol.new(decoded, true)
        end
      end

      def sequence_slashed_values(values, lang:)
        values.each_with_index do |value, index|
          decoded = HTMLEntities.new.decode(value.value)
          slashed = if index == 0
                      slashed_values(value.value)
                    else
                      decoded.match?(/[0-9]/) ? Math::Number.new(decoded) : symbols_class(decoded, lang: lang)
                    end
          values[index] = slashed
        end
        values
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
