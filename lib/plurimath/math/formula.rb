# frozen_string_literal: true

require_relative "../mathml/utility"

module Plurimath
  module Math
    class Formula < Core
      include Mathml::Utility

      attr_accessor :value, :left_right_wrapper, :displaystyle, :input_string, :display

      POWER_BASE_CLASSES = %w[powerbase power base].freeze
      DERIVATIVE_CONSTS  = ["&#x1d451;", "&#x2145;", "&#x2146;", "d"].freeze
      MATH_ZONE_TYPES    = %i[omml latex mathml asciimath unicodemath].freeze
      OMML_NAMESPACES    = {
        "xmlns:m": "http://schemas.openxmlformats.org/officeDocument/2006/math",
        "xmlns:mc": "http://schemas.openxmlformats.org/markup-compatibility/2006",
        "xmlns:mo": "http://schemas.microsoft.com/office/mac/office/2008/main",
        "xmlns:mv": "urn:schemas-microsoft-com:mac:vml",
        "xmlns:o": "urn:schemas-microsoft-com:office:office",
        "xmlns:r": "http://schemas.openxmlformats.org/officeDocument/2006/relationships",
        "xmlns:v": "urn:schemas-microsoft-com:vml",
        "xmlns:w": "http://schemas.openxmlformats.org/wordprocessingml/2006/main",
        "xmlns:w10": "urn:schemas-microsoft-com:office:word",
        "xmlns:w14": "http://schemas.microsoft.com/office/word/2010/wordml",
        "xmlns:w15": "http://schemas.microsoft.com/office/word/2012/wordml",
        "xmlns:wne": "http://schemas.microsoft.com/office/word/2006/wordml",
        "xmlns:wp": "http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing",
        "xmlns:wp14": "http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing",
        "xmlns:wpc": "http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas",
        "xmlns:wpg": "http://schemas.microsoft.com/office/word/2010/wordprocessingGroup",
        "xmlns:wpi": "http://schemas.microsoft.com/office/word/2010/wordprocessingInk",
        "xmlns:wps": "http://schemas.microsoft.com/office/word/2010/wordprocessingShape",
      }.freeze

      def initialize(
        value = [],
        left_right_wrapper = true,
        display_style: true,
        input_string: nil
      )
        @value = value.is_a?(Array) ? value : [value]
        left_right_wrapper = false if @value.first.is_a?(Function::Left)
        @left_right_wrapper = left_right_wrapper
        @displaystyle = boolean_display_style(display_style)
      end

      def ==(object)
        object.respond_to?(:value) &&
          object.respond_to?(:left_right_wrapper) &&
          object.value == value &&
          object.left_right_wrapper == left_right_wrapper
      end

      def to_asciimath(formatter: nil, unitsml: {}, options: nil)
        options ||= { formatter: formatter, unitsml: unitsml }.compact
        output = value.map do |val|
          val.to_asciimath(options: asciimath_table_options(options, val))
        end.join(" ")
      rescue
        parse_error!(:asciimath)
      end

      def to_mathml(
        intent: false,
        formatter: nil,
        unitsml: {},
        split_on_linebreak: false,
        display_style: displaystyle,
        unary_function_spacing: true
      )
        options = {
          formatter: formatter,
          unitsml: unitsml,
          unary_function_spacing: unary_function_spacing
        }.compact
        return line_breaked_mathml(display_style, intent, options: options) if split_on_linebreak

        math_attrs = {
          xmlns: "http://www.w3.org/1998/Math/MathML",
          display: "block",
        }
        style_attrs = { displaystyle: boolean_display_style(display_style) }
        math  = ox_element("math", attributes: math_attrs)
        style = ox_element("mstyle", attributes: style_attrs)
        Utility.update_nodes(style, mathml_content(intent, options: options))
        Utility.update_nodes(math, [style])
        unitsml_post_processing(math, style)
        dump_nodes(math, indent: 2)
      rescue
        parse_error!(:mathml)
      end

      def line_breaked_mathml(display_style, intent, options:)
        new_line_support.map do |formula|
          formula.to_mathml(
            display_style: display_style,
            intent: intent,
            formatter: options[:formatter],
            unary_function_spacing: options[:unary_function_spacing],
          )
        end.join
      end

      def to_mathml_without_math_tag(intent, options:)
        return mathml_content(intent, options: options) unless left_right_wrapper

        mathml_value = mathml_content(intent, options: options)
        attributes = intent_attribute(mathml_value) if intent
        mrow = ox_element("mrow", attributes: attributes)
        Utility.update_nodes(mrow, mathml_value)
      end

      def mathml_content(intent, options:)
        nodes = value.map { |val| val.to_mathml_without_math_tag(intent, options: options) }
        intent_post_processing(nodes, intent) if intent
        nodes
      end

      def to_latex(formatter: nil, unitsml: {}, options: nil)
        options ||= { formatter: formatter, unitsml: unitsml }.compact
        value.map { |val| val.to_latex(options: options) }.join(" ")
      rescue
        parse_error!(:latex)
      end

      def to_html(formatter: nil, unitsml: {}, options: nil)
        options ||= { formatter: formatter, unitsml: unitsml }.compact
        value&.map { |val| val.to_html(options: options) }&.join(" ")
      rescue
        parse_error!(:html)
      end

      def to_omml(display_style: displaystyle, split_on_linebreak: false, formatter: nil, unitsml: {})
        objects = split_on_linebreak ? new_line_support : [self]
        options = { formatter: formatter, unitsml: unitsml }.compact
        para_element = Utility.ox_element("oMathPara", attributes: OMML_NAMESPACES, namespace: "m")
        objects.each.with_index(1) do |object, index|
          para_element << Utility.update_nodes(
            Utility.ox_element("oMath", namespace: "m"),
            object.omml_content(boolean_display_style(display_style), options: options),
          )
          next if objects.length == index

          para_element << omml_br_tag
        end
        dump_nodes(para_element, indent: 2)
      rescue
        parse_error!(:omml)
      end

      def omml_content(display_style, options:)
        value&.map { |val| val.insert_t_tag(display_style, options: options) }
      end

      def to_omml_without_math_tag(display_style, options:)
        omml_content(display_style, options: options)
      end

      def to_unicodemath(formatter: nil, unitsml: {}, options: nil)
        options ||= { formatter: formatter, unitsml: unitsml }.compact
        Utility.html_entity_to_unicode(unicodemath_value(options: options)).gsub(/\s\/\s/, "/")
      rescue
        parse_error!(:unicodemath)
      end

      def to_display(type = nil, formatter: nil, unitsml: {}, unary_function_spacing: true)
        options = {
          formatter: formatter,
          unitsml: unitsml,
          unary_function_spacing: unary_function_spacing
        }
        return type_error!(type) unless MATH_ZONE_TYPES.include?(type.downcase.to_sym)

        math_zone = case type
                    when :asciimath
                      "  |_ \"#{to_asciimath(options: options)}\"\n#{to_asciimath_math_zone("     ", options: options).join}"
                    when :latex
                      "  |_ \"#{to_latex(options: options)}\"\n#{to_latex_math_zone("     ", options: options).join}"
                    when :mathml
                      mathml = to_mathml(formatter: formatter, unary_function_spacing: options[:unary_function_spacing]).gsub(/\n\s*/, "")
                      math_display = to_mathml_math_zone("     ", options: options).join
                      "  |_ \"#{mathml}\"\n#{math_display}"
                    when :omml
                      omml = to_omml.gsub(/\n\s*/, "")
                      omml_display = to_omml_math_zone("     ", display_style: displaystyle, options: options).join
                      "  |_ \"#{omml}\"\n#{omml_display}"
                    when :unicodemath
                      "  |_ \"#{to_unicodemath(options: options)}\"\n#{to_unicodemath_math_zone("     ", options: options).join}"
                    end
        <<~MATHZONE.sub(/\n$/, "")
        |_ Math zone
        #{math_zone}
        MATHZONE
      end

      def to_asciimath_math_zone(spacing = "", last = false, indent = true, options:)
        filtered_values(value, lang: :asciimath).map.with_index(1) do |object, index|
          last = index == @values.length
          object.to_asciimath_math_zone(new_space(spacing, indent), last, indent, options: options)
        end
      end

      def to_latex_math_zone(spacing = "", last = false, indent = true, options:)
        filtered_values(value, lang: :latex).map.with_index(1) do |object, index|
          last = index == @values.length
          object.to_latex_math_zone(new_space(spacing, indent), last, indent, options: options)
        end
      end

      def to_mathml_math_zone(spacing = "", last = false, indent = true, options:)
        filtered_values(value, lang: :mathml, options: options).map.with_index(1) do |object, index|
          last = index == @values.length
          object.to_mathml_math_zone(new_space(spacing, indent), last, indent, options: options)
        end
      end

      def to_omml_math_zone(spacing = "", last = false, indent = true, display_style:, options:)
        filtered_values(value, lang: :omml).map.with_index(1) do |object, index|
          last = index == @values.length
          object.to_omml_math_zone(new_space(spacing, indent), last, indent, display_style: display_style, options: options)
        end
      end

      def to_unicodemath_math_zone(spacing = "", last = false, indent = true, options:)
        filtered_values(value, lang: :unicodemath).map.with_index(1) do |object, index|
          last = index == @values.length
          object.to_unicodemath_math_zone(new_space(spacing, indent), last, indent, options: options)
        end
      end

      def extract_class_name_from_text
        return unless value.length < 2 && value.first.is_a?(Function::Text)

        value.first.parameter_one
      end

      def nary_attr_value(options:)
        value.first.nary_attr_value(options: Hash.new(options))
      end

      def validate_function_formula
        (value.none?(Function::Left) || value.none?(Function::Right))
      end

      def value_exist?
        value && !value.empty?
      end

      def update(object)
        @value = Array(object).flatten.compact
      end

      def cloned_objects
        cloned_obj = value.map(&:cloned_objects)
        formula = self.class.new(cloned_obj)
        formula.left_right_wrapper = @left_right_wrapper
        formula
      end

      def new_line_support(array = [])
        cloned = cloned_objects
        obj = self.class.new
        cloned.line_breaking(obj)
        array << cloned
        obj.value_exist? ? obj.new_line_support(array) : array
      end

      def line_breaking(obj)
        if result.size > 1
          breaked_result = result.first.last.omml_line_break(result)
          update(Array(breaked_result.shift))
          obj.update(breaked_result.flatten)
          reprocess_value(obj)
          return
        end

        value.each.with_index(1) do |object, index|
          object.line_breaking(obj)
          break obj.insert(value.slice!(index..value.size)) if obj.value_exist?
        end
      end

      def reprocess_value(obj)
        new_obj = self.class.new([])
        self.line_breaking(new_obj)
        if new_obj.value_exist?
          obj.value.insert(0, Function::Linebreak.new)
          obj.value.insert(0, self.class.new(new_obj.value))
        end
      end

      def insert(values)
        update(Array(value) + values)
      end

      def mini_sized?
        true if value&.first&.mini_sized?
      end

      def intent_names
        {
          partial_derivative: ":partial-derivative",
          derivative: ":derivative",
        }
      end

      def element_order=(value)
        @value = validated_order(value.map(&:name))
      end

      # Attributes start
      def mathcolor=(value)
        return if value.nil? || value.empty?

        update(
          [
            Math::Function::Color.new(
              Math::Function::Text.new(value),
              filter_values(@value, array_to_instance: true),
            )
          ]
        )
      end

      def mathvariant=(value)
        return if value.nil? || value.empty?
        return unless Plurimath::Utility::FONT_STYLES.key?(value.to_sym)

        update(
          [
            Plurimath::Utility::FONT_STYLES[value.to_sym].new(
              filter_values(@value, array_to_instance: true),
              value,
            )
          ]
        )
      end

      def intent=(value)
        return unless value

        self.content = nil
        update(
          [
            Function::Intent.new(
              filter_values(@value, array_to_instance: true),
              Function::Text.new(value),
            )
          ]
        )
      end
      # Attributes end

      def ms_value=(value)
        return if value.nil? || value.empty?

        update(
          replace_order_with_value(
            @value,
            Array(validate_symbols(value)),
            "ms"
          )
        )
      end

      def mi_value=(value)
        return if value.nil? || value.empty?

        value = update_temp_mathml_values(value) if value.any? do |val|
          val.is_a?(Math::Core) && val.temp_mathml_order.any?
        end
        update(
          replace_order_with_value(
            @value,
            Array(validate_symbols(value)).flatten,
            "mi"
          )
        )
      end

      def mn_value=(value)
        return if value.nil? || value.empty?

        update(
          replace_order_with_value(
            @value,
            Array(validate_symbols(value)),
            "mn"
          )
        )
      end

      def mtext_value=(value)
        return if value.nil? || value.empty?

        update(
          replace_order_with_value(
            @value,
            Array(validate_symbols(value)),
            "mtext"
          )
        )
      end

      def mo_value=(value)
        return if value.nil? || value.empty?

        value = update_temp_mathml_values(value)
        update(
          replace_order_with_value(
            @value,
            Array(value),
            "mo"
          )
        )
      end

      def mstyle_value=(value)
        return if value.nil? || value.empty?

        update(
          filter_values(
            replace_order_with_value(
              @value,
              Array(filter_values(value, array_to_instance: true)),
              "mstyle"
            )
          )
        )
      end

      def mrow_value=(value)
        return if value.nil? || value.empty?

        replacing_order = value.length > 1 && value.any?(String)
        update(
          replace_order_with_value(
            @value,
            filter_values(
              value,
              array_to_instance: true,
              replacing_order: replacing_order
            ),
            "mrow"
          )
        )
      end

      def munderover_value=(value)
        update_temp_order(value, "munderover")
      end

      def msub_value=(value)
        update_temp_order(value, "msub")
      end

      def msup_value=(value)
        update_temp_order(value, "msup")
      end

      def mover_value=(value)
        update_temp_order(value, "mover")
      end

      def munder_value=(value)
        update_temp_order(value, "munder")
      end

      def msubsup_value=(value)
        update_temp_order(value, "msubsup")
      end

      def mfrac_value=(value)
        update_temp_order(value, "mfrac")
      end

      def msqrt_value=(value)
        update_temp_order(value, "msqrt")
      end

      def mfenced_value=(value)
        update_temp_order(value, "mfenced")
      end

      def mroot_value=(value)
        update_temp_order(value, "mroot")
      end

      def msgroup_value=(value)
        update_temp_order(value, "msgroup")
      end

      def mscarries_value=(value)
        update_temp_order(value, "mscarries")
      end

      def msline_value=(value)
        update_temp_order(value, "msline")
      end

      def msrow_value=(value)
        update_temp_order(value, "msrow")
      end

      def semantics_value=(value)
        update_temp_order(value, "semantics")
      end

      def mstack_value=(value)
        update_temp_order(value, "mstack")
      end

      def merror_value=(value)
        return if value.nil? || value.empty?

        update(
          replace_order_with_value(
            @value,
            filter_values(update_temp_mathml_values(value)),
            "merror"
          )
        )
      end

      def mlongdiv_value=(value)
        update_temp_order(value, "mlongdiv")
      end

      def none_value=(_)
        @value&.delete("none")
      end

      def maligngroup_value=(value)
        @value&.delete("maligngroup")
      end

      def menclose_value=(value)
        update_temp_order(value, "menclose")
      end

      def mspace_value=(value)
        return if value.nil? || value.empty?

        if value.first.linebreak
          linebreak = Math::Function::Linebreak.new(
            nil,
            { linebreak: value.first.linebreak }
          )
          update(
            replace_order_with_value(
              @value,
              [linebreak],
              "mspace"
            )
          )
        else
          @value&.delete("mspace")
        end
      end

      def malignmark_value=(value)
        @value&.delete("malignmark")
      end

      def mpadded_value=(value)
        update_temp_order(value, "mpadded")
      end

      def mfraction_value=(value)
        update_temp_order(value, "mfraction")
      end

      def mmultiscripts_value=(value)
        update_temp_order(value, "mmultiscripts")
      end

      def mphantom_value=(value)
        update_temp_order(value, "mphantom")
      end

      def mglyph_value=(value)
        update_temp_order(value, "mglyph")
      end

      protected

      def asciimath_table_options(options, object)
        return options unless options.key?(:table) && object.is_a?(Math::Symbols::Comma)

        options.merge(literal_comma: true)
      end

      def update_temp_order(value, order_name)
        return if value.nil? || value.empty?

        update(
          replace_order_with_value(
            Array(@value),
            Array(update_temp_mathml_values(value)),
            order_name
          )
        )
      end

      def remove_order(order)
        value.delete_if { |val| val.is_a?(String) && val == order }
      end

      def boolean_display_style(display_style = displaystyle)
        YAML.safe_load(display_style.to_s)
      end

      def new_space(spacing, indent)
        if value.any? { |val| val.class_name == "left" } && value.any? { |val| val.class_name == "right" }
          return spacing
        end

        (indent && wrapable?(spacing)) ? spacing + "|_ " : spacing
      end

      def wrapable?(spacing)
        left_right_wrapper && !spacing.end_with?("|_ ")
      end

      def parse_error!(type)
        Math.parse_error!(input_string, type)
      end

      def omml_br_tag
        r_tag = ox_element("r", namespace: "m")
        r_tag << ox_element("br")
      end

      def unitsml_post_processing(math, style)
        if all_unitsml_nodes?(style)
          style.nodes.first.remove_attr("unitsml")
        else
          unitsml_processing(math.nodes, math)
        end
      end

      def all_unitsml_nodes?(style)
        return false unless style.nodes.one?

        style.nodes.first.attributes["unitsml"] == "true"
      end

      def unitsml_processing(nodes, prev_node)
        insert_index = 0
        nodes.each.with_index do |node, index|
          if node[:unitsml]
            prev_node.insert_in_nodes(index + insert_index, space_element)
            insert_index += 1
            node.remove_attr("unitsml")
          end
          unitsml_processing(node.nodes, node) if node.nodes.none?(String)
        end
      end

      def space_element
        element = (ox_element("mo") << "&#x2062;")
        element[:rspace] = "thickmathspace"
        element
      end

      def negated_value?
        value.last.is_a?(Math::Symbols::Symbol) && value.last.value == "&#x338;"
      end

      def unicodemath_value(options:)
        join_str = " " if !(negated_value? || mini_sized?)
        value&.map { |v| v.to_unicodemath(options: options) }&.join(join_str)
      end

      def intent_attribute(mathml)
        return unless mathml || value.length != 2
        return unless valid_first_parameter?(value.first)

        { intent: ":function" }
      end

      def valid_first_parameter?(param)
        undef_functions = UnicodeMath::Constants::UNDEF_UNARY_FUNCTIONS
        return true if param.is_a?(Symbols::Symbol) && undef_functions.include?(param.value)
        return unless POWER_BASE_CLASSES.include?(param.class_name)

        param.parameter_one.is_a?(Function::UnaryFunction) ||
          param.parameter_one.is_a?(Function::Lim)
      end

      def intent_post_processing(nodes, intent)
        mrow = Utility.update_nodes(ox_element("mrow"), nodes)
        upcase_dd_derivative(nodes) if validate_upcase_dd_derivatives?(nodes)
        subsup_dd_derivative(nodes) if validate_subsup_dd_derivatives?(nodes)
        partial_derivative(nodes) if valid_partial_derivative?(nodes)
        update_partial_derivative_nodes(nodes) unless mrow.locate("*/mfrac/@arg").empty?
      end

      # Partial derivative nodes begin
      def update_partial_derivative_nodes(nodes)
        nodes.reduce do |first, second|
          if valid_partial_node(first)
            if %w[mfrac mo].include?(second.name)
              first["intent"] = first["intent"].gsub("$f", "")
            else
              second["arg"] = "f"
            end
          end
          second
        end
      end

      def valid_partial_node(node)
        return unless node.name == "mfrac"

        node["intent"]&.start_with?(":partial-derivative") &&
          !node.locate("*/@arg").include?("f")
      end

      def valid_partial_derivative?(nodes)
        valid = false
        nodes.reduce do |first, second|
          next second unless first.name == "msub"

          valid = true if first.nodes[0].nodes[0] == "&#x2202;" && second
          second
        end
        valid
      end

      def partial_derivative(nodes)
        nodes.each.with_index do |first, index|
          second = nodes[index+1]
          next second unless first.name == "msub" && first.nodes.first.nodes.include?("&#x2202;")

          first["intent"] = partial_derivative_intent(first)
          f_arg(nodes, index+1)
        end
      end

      def partial_derivative_intent(first)
        first_node = first.nodes.last
        case first_node.name
        when "mi"
          first_arg, second_arg = [1, encode(first_node.nodes.first)]
        when "mn"
          first_arg, second_arg = numeric_encoding(node)
        when "mrow"
          str = ""
          first_node.nodes.each do |node|
            case node.name
            when "mi"
              str += encode(node.nodes.first)
            when "mn"
              str += numeric_encoding(node).last if str.empty?
              break
            end
          end
          first_arg = str.include?(",") ? str.split(",").length : str.length
          second_arg = str.include?(",") ? str : str.split("").join(",")
        when "msup"
          nodes = first_node.nodes
          str = ""
          case nodes.first.name
          when "mrow"
            nodes.first.nodes.each do |node|
              case node.name
              when "mi"
                str += encode(node.nodes.first)
              when "mn"
                str += numeric_encoding(node).last if str.empty?
                break
              end
            end
          when "mi"
            str += encode(node.nodes.first)
          end
          first_arg = str.include?(",") ? str.split(",").length : str.length
          second_arg = str.include?(",") ? str : str.split("").join(",")
          prime_str = encode(nodes.last.nodes.first) if valid_prime?(nodes.last)
          second_arg.insert(-1, prime_str) unless second_arg.match?(/[0-9]$/)
        end
        "#{intent_names[:partial_derivative]}(#{first_arg},$f,#{second_arg})"
      end

      def f_arg(tag_nodes, index)
        nodes = []
        while index <= tag_nodes.length
          node = tag_nodes[index]
          break unless node

          case node.name
          when "mrow"
            nodes << tag_nodes.delete_at(index)
            break
          when "mi"
            nodes << tag_nodes.delete_at(index)
          when "mn"
            nodes << tag_nodes.delete_at(index) if nodes.empty?
            break
          else
            break
          end
        end
        mrow = if nodes.length == 1
                 node = nodes.first
                 node["arg"] = "f"
                 node
               else
                 Utility.update_nodes(
                   ox_element("mrow", attributes: { arg: "f" }),
                   nodes,
                 )
               end
        tag_nodes.insert(index, mrow)
      end
      # Partial derivative nodes end

      # Dd derivative nodes begin
      def validate_subsup_dd_derivatives?(nodes)
        nodes.find.with_index do |node, index|
          next unless %w[msub msup msubsup].include?(node.name)

          next_node = nodes[index + 1]
          next unless next_node
          next if next_node.name == "mo"

          DERIVATIVE_CONSTS.include?(node.nodes.first.nodes.first)
        end
      end

      def validate_upcase_dd_derivatives?(nodes)
        return unless nodes[0]&.nodes&.first == "&#x2145;"
        return unless nodes[1].name == "mi"

        true
      end

      def upcase_dd_derivative(nodes)
        mrow_nodes = []
        while true
          node = nodes[1]
          case node.name
          when "mi"
            mrow_nodes << nodes.delete_at(1)
            next
          when "mrow"
            second_arg = mrow_nodes.map { |n| encode(n.nodes.first) }.join
            third_arg  = upcase_dd_intent_name(node.nodes[1..-2])
            mrow_nodes << nodes.delete_at(1)
            break
          end
          break
        end
        intent_name = "#{intent_names[:derivative]}(1,#{second_arg},#{third_arg})"
        mrow = ox_element("mrow", attributes: { intent: intent_name })
        nodes.insert(0, Utility.update_nodes(mrow, mrow_nodes))
      end

      def subsup_dd_derivative(nodes)
        iteration = 0
        return unless DERIVATIVE_CONSTS.include?(nodes[iteration].nodes[iteration].nodes.first)

        while iteration < nodes.length do
          node = nodes[iteration]
          next iteration += 1 unless node.nodes[0].is_a?(Plurimath::XmlEngine::OxEngine::Element)

          if DERIVATIVE_CONSTS.include?(node.nodes[0]&.nodes&.first)
            iteration += 1
            node["intent"] = "#{intent_names[:derivative]}#{derivative_intent_name(node.nodes[1], nodes[iteration..-1], type: node.name)}"
            next_node = nodes[iteration]
            case next_node.name
            when "mi", "mrow"
              if ["mi", "mrow"].include?(nodes[iteration + 1].name)
                wrap_in_mrow(nodes[iteration..-1])
              else
                next_node["arg"] = "f"
              end
            end
          end
          iteration += 1
        end
      end

      def derivative_intent_name(node, next_nodes, type:)
        case type
        when "msub"
          first_value, second_value = sub_intent_content(node)
          "(#{first_value},$f,#{second_value})"
        when "msup"
          "(#{sup_intent_content(node)},$f,#{sup_second_content(next_nodes)})"
        end
      end

      def sub_intent_content(node)
        return ["1", encode(node.nodes[0])] if node.name == "mi"
        return numeric_encoding(node) if node.name == "mn"
        return ["1"] if node["intent"] == "fenced"
        return unless node.name == "mrow"
        return ["1"] unless node.nodes.all? { |element| element.name == "mi" }
      end

      def sup_intent_content(node)
        return encode(first_node) if node.name == "mi"
        return node.nodes[0] if node.name == "mn"
        return "$n" if node.name == "mrow"
      end

      def sup_second_content(next_nodes)
        fence_node = nil
        next_nodes.each do |node|
          break if fence_node

          next if %w[mi mn].include?(node.name)
          fence_node = node if node.name == "mrow" && node["intent"] == ":fenced"
          break unless %w[mi mn].include?(node.name)
        end
        return if fence_node.nil?

        nodes = fence_node.nodes[1..-1]
        sliced_nodes = nodes.slice_before { |node| node.name == "mn" }
        str = ""
        sliced_nodes.to_a.last.each do |node|
          break unless %w[msub msup msubsup mi mn].include?(node.name)

          case node.name
          when "msub", "msup", "msubsup"
            powerbase_nodes = node.nodes
            str += encode(powerbase_nodes.first.nodes.first)
            str += encode(powerbase_nodes.last.nodes.first) if valid_prime?(powerbase_nodes.last)
          when "mi", "mn"
            str += node.nodes.first
          end
        end
        str
      end

      def wrap_in_mrow(nodes)
        mrow = ox_element("mrow", attributes: { arg: "f" })
        row_nodes = []
        loop do
          node = nodes.shift if ["mi", "mrow"].include?(nodes[0].name)
          row_nodes << node
          next if node.name == "mi"
          break if node.name == "mrow"
        end
        Utility.update_nodes(mrow, row_nodes)
      end

      def numeric_encoding(node)
        nodes = node.nodes[0].split("")
        [nodes.length, nodes.join(",")]
      end

      def valid_prime?(node)
        Utility.primes_constants.values.any? { |prime| prime == node.nodes.first }
      end

      def encode(str)
        Utility.html_entity_to_unicode(str)
      end

      def upcase_dd_intent_name(nodes)
        str = ""
        nodes.each do |node|
          case node.name
          when "mi"
            str += node.nodes.first
          when "mn"
            str = node.nodes.first
          when "msub", "msup", "msubsup"
            next unless %w[mi mn].include?(node.nodes[0].name)

            str = node.nodes[0] if node.nodes.first.name == "mn"
            str += node.nodes[0].nodes[0] if node.nodes.first.name == "mi"
            sup_index = node.name == "msubsup" ? 2 : 1
            str += node.nodes[sup_index].nodes[0] if valid_prime?(node.nodes[sup_index])
          else
            str = "" if node.name == "mfrac"
            break
          end
        end
        encode(str)
      end
      # Dd derivative nodes end

      def type_error!(type)
        raise Math::InvalidTypeError.new(
          "Invalid type provided: #{type}. Must be one of #{MATH_ZONE_TYPES.join(', ')}.",
        )
      end
    end
  end
end
