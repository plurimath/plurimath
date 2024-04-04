# frozen_string_literal: true

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
      unicode
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

    class << self
      def organize_table(array, column_align: nil, options: nil)
        table = []
        table_data = []
        table_row = []
        organize_options(array, column_align) if options
        string_columns = column_align&.map(&:value)
        array.each do |data|
          if data&.separate_table
            table_row << Math::Function::Td.new(filter_table_data(table_data).compact)
            table_data = []
            if data.linebreak
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
        table_data.map do |tr|
          if symbol_value(tr&.parameter_one&.first&.parameter_one&.first, "&#x23af;")
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
        tr_array.map.with_index do |td, ind|
          columnalign = ALIGNMENT_LETTERS[column_align[ind]&.to_sym]
          td.parameter_two = { columnalign: columnalign } if columnalign
        end
      end

      def filter_table_data(table_data)
        table_data.each_with_index do |object, ind|
          if symbol_value(object, "-")
            table_data[ind] = Math::Formula.new(
              [object, table_data.delete_at(ind.next)],
            )
          end
        end
        table_data
      end

      def get_table_class(text)
        Object.const_get(
          "Plurimath::Math::Function::Table::#{text.to_s.capitalize}",
        )
      end

      def sub_sup_method?(sub_sup)
        if sub_sup.methods.include?(:class_name)
          Html::Constants::SUB_SUP_CLASSES.value?(sub_sup.class_name.to_sym)
        end
      end

      def get_class(text)
        text = text.to_s.split("_").map(&:capitalize).join
        Object.const_get(
          "Plurimath::Math::Function::#{text}",
        )
      end

      def ox_element(node, attributes: [], namespace: "")
        namespace = "#{namespace}:" unless namespace.empty?

        element = Plurimath.xml_engine.new_element("#{namespace}#{node}")
        attributes&.each do |attr_key, attr_value|
          element[attr_key] = attr_value
        end
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

      def filter_values(array)
        return array unless array.is_a?(Array) || array.is_a?(Math::Formula)

        array = array.is_a?(Math::Formula) ? array.value : array.flatten.compact
        return Math::Formula.new(array) if array.length > 1

        array.first
      end

      def text_classes(text)
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
          Math::Symbol.new(text)
        end
      end

      def nary_fonts(nary)
        narypr  = nary.first.flatten.compact
        subsup  = narypr.any?("undOvr") ? "undOvr" : "subSup"
        unicode = narypr.any?(Hash) ? narypr.first[:chr] : "∫"
        Math::Function::Nary.new(
          Math::Symbol.new(string_to_html_entity(unicode)),
          filter_values(nary[1]),
          filter_values(nary[2]),
          filter_values(nary[3]),
          { type: subsup }
        )
      end

      def find_pos_chr(fonts_array, key)
        fonts_array.find { |d| d.is_a?(Hash) && d[key] }
      end

      def td_values(objects, slicer)
        sliced = objects.slice_when { |object, _| symbol_value(object, slicer) }
        tds = sliced.map do |slice|
          Math::Function::Td.new(
            slice.delete_if { |d| symbol_value(d, slicer) }.compact,
          )
        end
        tds << Math::Function::Td.new([]) if symbol_value(objects.last, slicer)
        tds
      end

      def symbol_value(object, value)
        (object.is_a?(Math::Symbol) && object.value.include?(value)) ||
          (value == "\\\\" && object.is_a?(Math::Function::Linebreak))
      end

      def td_value(td_object)
        str_classes = [String, Parslet::Slice]
        if str_classes.include?(td_object.class) && td_object.to_s.empty?
          return Math::Function::Text.new(nil)
        end

        td_object
      end

      def mathml_unary_classes(text_array, omml: false, unicode_only: false)
        return [] if text_array.empty?

        compacted = text_array.compact
        return filter_values(compacted) unless compacted.any?(String)

        string  = compacted.join
        classes = Mathml::Constants::CLASSES
        unicode = string_to_html_entity(string)
        return Math::Symbol.new(unicode) if unicode_only && unicode

        symbol = Mathml::Constants::UNICODE_SYMBOLS[unicode.strip.to_sym]
        if classes.include?(symbol&.strip)
          get_class(symbol.strip).new
        elsif classes.any?(string&.strip)
          get_class(string.strip).new
        else
          omml ? text_classes(string) : Math::Symbol.new(unicode)
        end
      end

      def string_to_html_entity(string)
        entities = HTMLEntities.new
        entities.encode(string, :hexadecimal)
      end

      def html_entity_to_unicode(string)
        entities = HTMLEntities.new
        entities.decode(string)
      end

      def table_separator(separator, value, symbol: "solid")
        sep_symbol = Math::Function::Td.new([Math::Symbol.new("|")])
        separator&.each_with_index do |sep, ind|
          next unless sep == symbol

          value.map do |val|
            val.parameter_one.insert((ind + 1), sep_symbol) if symbol == "solid"
            val.parameter_one.insert(ind, sep_symbol) if symbol == "|"
            (val.parameter_one[val.parameter_one.index(nil)] = Math::Function::Td.new([])) rescue nil
            val
          end
        end
        value
      end

      def join_attr_value(attrs, value, unicode_only: false)
        if value.any?(String)
          new_value = mathml_unary_classes(value, unicode_only: unicode_only)
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
              symbol_object(attrs[:open] || "("),
              value,
              symbol_object(attrs[:close] || ")"),
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

      def multiscript(values)
        values.slice_before("mprescripts").map do |value|
          base_value   = value.shift
          value        = nil_to_none_object(value)
          part_val     = value.partition.with_index { |_, i| i.even? }
          first_value  = part_val[0].empty? ? nil : part_val[0]
          second_value = part_val[1].empty? ? nil : part_val[1]
          if base_value.to_s.include?("mprescripts")
            [first_value, second_value]
          else
            Math::Function::PowerBase.new(
              filter_values(base_value),
              filter_values(first_value),
              filter_values(second_value),
            )
          end
        end
      end

      def nil_to_none_object(value)
        return value unless value.any?(NilClass) || value.any? { |val| val.is_a?(Array) && val.empty? }

        value.each.with_index do |val, index|
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
        object.parameter_one.value == "(" &&
          object.parameter_three.value == ")" &&
          !object.options.keys.any? { |k| [:open_paren, :close_paren].any?(k.to_sym) } &&
          !object.parameter_one.mini_sup_sized &&
          !object.parameter_three.mini_sub_sized &&
          object.options.empty?
      end

      def frac_values(object)
        case object
        when Math::Formula
          object.value.any? { |d| symbol_value(d, ",") }
        when Array
          object.any? { |d| symbol_value(d, ",") }
        end
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

      def symbol_object(value)
        value = case value
                when "ℒ" then "{:"
                when "ℛ" then ":}"
                when "ᑕ" then "&#x2329;"
                when "ᑐ" then "&#x232a;"
                else value
                end
        Math::Symbol.new(value)
      end

      def validate_left_right(fields = [])
        fields.each do |field|
          if field.is_a?(Math::Formula) && field.value.first.is_a?(Math::Function::Left)
            field.left_right_wrapper = true
          end
        end
      end

      def left_right_objects(paren, function)
        paren = if paren.to_s.match?(/\\\{|\\\}/)
                  paren.to_s.gsub(/\\/, "")
                else
                  Latex::Constants::LEFT_RIGHT_PARENTHESIS[paren.to_sym]
                end
        get_class(function).new(paren)
      end

      def valid_class(object)
        text = object.extract_class_name_from_text
        (object.extractable? && Asciimath::Constants::SUB_SUP_CLASSES.include?(text)) ||
          Latex::Constants::SYMBOLS[text.to_sym] == :power_base
      end

      def mrow_left_right(mrow = [])
        object = mrow.first
        !(
          ((object.is_a?(Math::Function::TernaryFunction) && object.any_value_exist?) && (mrow.length <= 2)) ||
          (object.is_a?(Math::Function::UnaryFunction) && mrow.length == 1)
        )
      end

      def populate_function_classes(mrow = [])
        flatten_mrow = mrow.flatten.compact
        unary_function_classes(flatten_mrow)
        binary_function_classes(flatten_mrow)
        ternary_function_classes(flatten_mrow)
        flatten_mrow
      end

      def binary_function_classes(mrow, under: false)
        binary_class = Math::Function::BinaryFunction
        mrow.each_with_index do |object, ind|
          mrow[ind] = mathml_unary_classes([object]) if object.is_a?(String)
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

      def unary_function_classes(mrow)
        unary_class = Math::Function::UnaryFunction
        if mrow.any?(String) || mrow.any?(unary_class)
          mrow.each_with_index do |object, ind|
            mrow[ind] = mathml_unary_classes([object]) if object.is_a?(String)
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

      def paren_able?(arr = [], mrow = [])
        arr.any? do |opening, closing|
          symbol_value(mrow.first, opening.to_s) && symbol_value(mrow.last, closing.to_s)
        end
      end

      def fenceable_classes(mrow = [])
        return false unless mrow.length > 1

        if paren_able?(PARENTHESIS, mrow)
          open_paren = mrow.shift
          close_paren = mrow.pop
          if mrow.length == 1 && mrow.first.is_a?(Math::Function::Table)
            table = mrow.first
            table.open_paren = open_paren.value
            table.close_paren = close_paren.value
          else
            mrow.replace(
              [
                Math::Function::Fenced.new(open_paren, mrow.dup, close_paren),
              ],
            )
          end
        end
      end

      def validate_math_zone(object)
        return false unless object

        if object.is_a?(Math::Formula)
          filter_math_zone_values(object.value).find do |d|
            !d.is_a?(Math::Function::Text)
          end
        else
          !TEXT_CLASSES.include?(object.class_name)
        end
      end

      def filter_math_zone_values(value)
        return [] if value&.empty?

        new_arr = []
        temp_array = []
        skip_index = nil
        value.each_with_index do |obj, index|
          object = obj.dup
          next if index == skip_index
          next temp_array << object.value if TEXT_CLASSES.include?(object.class_name)

          new_arr << Math::Function::Text.new(temp_array.join(" ")) if temp_array.any?
          temp_array = []
          new_arr << object
        end
        new_arr << Math::Function::Text.new(temp_array.join(" ")) if temp_array.any?
        new_arr
      end

      def unicode_accents(accents)
        if accents.is_a?(Math::Function::BinaryFunction)
          accents
        else
          if accents.any? { |acc| acc&.dig(:first_value)&.is_a?(Array) }
            accent_value = accents.first[:first_value].pop
            first_value = accents.first[:first_value]
            accents.first[:first_value] = accent_value
            Math::Formula.new(
              first_value + [transform_accents(accents)]
            )
          else
            transform_accents(accents)
          end
        end
      end

      def transform_accents(accents)
        accents.reduce do |function, accent|
          if function.is_a?(Hash)
            if function[:prime_accent_symbols]
              Math::Function::Power.new(
                unfenced_value(accent_value(function, function: true), paren_specific: true),
                accent_value(accent),
              )
            else
              Math::Function::Overset.new(
                accent_value(accent),
                unfenced_value(accent_value(function, function: true), paren_specific: true),
                { accent: true }
              )
            end
          else
            if accent[:prime_accent_symbols]
              Math::Function::Power.new(
                unfenced_value(function, paren_specific: true),
                accent_value(accent),
              )
            else
              Math::Function::Overset.new(
                accent_value(accent),
                unfenced_value(function, paren_specific: true),
                { accent: true }
              )
            end
          end
        end
      end

      def accent_value(accent, function: false)
        if accent[:accent_symbols]
          Math::Symbol.new(accent[:accent_symbols])
        else
          accent[:first_value] || filter_values(accent[:prime_accent_symbols])
        end
      end

      def unicode_fractions(fractions)
        frac_arr = UnicodeMath::Constants::UNICODE_FRACTIONS[fractions.to_sym]
        Math::Function::Frac.new(
          Math::Number.new(frac_arr.first.to_s, ),
          Math::Number.new(frac_arr.last.to_s, ),
          { displaystyle: false, unicodemath_fraction: true }
        )
      end

      def fractions(numerator, denominator, options = nil)
        frac_class = Math::Function::Frac
        if denominator.is_a?(frac_class)
          if denominator.parameter_one.is_a?(frac_class)
            recursion_fraction(denominator, numerator, options)
          else
            denominator.parameter_one = frac_class.new(
              unfenced_value(numerator, paren_specific: true),
              unfenced_value(denominator.parameter_one, paren_specific: true),
              options
            )
          end
          denominator
        else
          frac_class.new(
            unfenced_value(numerator, paren_specific: true),
            unfenced_value(denominator, paren_specific: true),
            options
          )
        end
      end

      def recursion_fraction(frac, numerator, options)
        frac_class = Math::Function::Frac
        new_numerator = frac.parameter_one
        if new_numerator.is_a?(frac_class)
          recursion_fraction(new_numerator, numerator, options)
        else
          frac.parameter_one = frac_class.new(
            unfenced_value(numerator, paren_specific: true),
            unfenced_value(frac.parameter_one, paren_specific: true),
            options
          )
          frac
        end
      end

      def recursive_sub(sub_script, sub_recursion)
        base_class = Math::Function::Base
        if sub_recursion.is_a?(base_class)
          if sub_recursion.parameter_one.is_a?(base_class)
            base_recursion(sub_script, sub_recursion)
          else
            sub_recursion.parameter_one = base_class.new(sub_script, sub_recursion.parameter_one)
          end
          sub_recursion
        else
          base_class.new(
            sub_script,
            sub_recursion,
          )
        end
      end

      def base_recursion(sub_script, sub_recursion)
        base_class = Math::Function::Base
        new_sub = sub_recursion.parameter_one
        if new_sub.is_a?(base_class)
          base_recursion(sub_script, new_sub)
          sub_recursion
        else
          sub_recursion.parameter_one = base_class.new(sub_script, new_sub)
          sub_recursion
        end
      end

      def recursive_sup(sup_script, sup_recursion)
        power_class = Math::Function::Power
        if sup_recursion.is_a?(power_class)
          if sup_recursion.parameter_one.is_a?(power_class)
            sup_recursion(sup_script, sup_recursion)
          else
            sup_recursion.parameter_one = power_class.new(sup_script, sup_recursion.parameter_one)
          end
          sup_recursion
        else
          power_class.new(
            sup_script,
            sup_recursion,
          )
        end
      end

      def sup_recursion(sup_script, sup_recursion)
        power_class = Math::Function::Power
        new_sup = sup_recursion.parameter_one
        if new_sup.is_a?(power_class)
          sup_recursion(sup_script, new_sup)
          sup_recursion
        else
          sup_recursion.parameter_one = power_class.new(sup_script, new_sup)
          sup_recursion
        end
      end

      def base_is_prime?(base)
        UnicodeMath::Constants::PREFIXED_PRIMES.key(base.parameter_two.value) ||
          (base.parameter_two.value == "&#x27;")
      end

      def base_is_sub_or_sup?(base)
        if base.is_a?(Math::Formula)
          base_is_sub_or_sup?(base.value.first)
        elsif base.is_a?(Math::Function::Fenced)
          base_is_sub_or_sup?(base.parameter_two.first)
        elsif base.is_a?(Math::Symbol) || base.is_a?(Math::Number)
          base.mini_sub_sized || base_mini_sup_sized
        end
      end

      def identity_matrix(size)
        matrix = Array.new(size) { Array.new(size, 0) }
        size.times { |i| matrix[i][i] = 1 }
        matrix.map do |tr|
          tr.map.with_index do |td, i|
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
    end
  end
end
