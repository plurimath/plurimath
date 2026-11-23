# frozen_string_literal: true

module Plurimath
  module Math
    class Formula < Core
      # Include the shared base on first tree use so subclass super calls keep
      # their lookup order while conversion leaves the implementation unloaded.
      autoload :DisplayTreeMethods, "plurimath/math/formula/display_tree_methods"

      autoload :Mrow, "#{__dir__}/formula/mrow"
      autoload :Mstyle, "#{__dir__}/formula/mstyle"
      autoload :ClassTree, "#{__dir__}/formula/class_tree"
      autoload :IntentProcessing, "#{__dir__}/formula/intent_processing"

      include Mathml::FormulaTransformation

      node_fields :value, collections: %i[value],
                          scalars: { left_right_wrapper: :boolean,
                                     displaystyle: :boolean,
                                     input_string: :string },
                          values: %i[display]

      POWER_BASE_CLASSES = %w[powerbase power base].freeze
      DERIVATIVE_CONSTS  = ["&#x1d451;", "&#x2145;", "&#x2146;", "d"].freeze
      MATH_ZONE_TYPES    = %i[omml latex mathml asciimath unicodemath formula].freeze
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

      attr_accessor :openmath_source, :openmath_snapshot

      def openmath_source_current?
        openmath_source && self == openmath_snapshot
      end

      def to_openmath(version: 2)
        Plurimath::Openmath::Writer.new.serialize(self, version: version)
      end

      def to_content_mathml(version: 2)
        ::Openmath::ContentMathML.generate(to_openmath(version: version),
                                          version: version)
      rescue ::Openmath::ContentMathML::Error => e
        raise Plurimath::Openmath::UnsupportedError.new(e.message, :content_mathml)
      end

      # Keyword shorthand bindings (evaluate(a: 2)) are absorbed into the
      # bindings hash; pass bindings positionally when a key collides with
      # an option name (mode:, guard_digits:).
      def evaluate(bindings = {}, mode: nil, guard_digits: nil, **rest)
        bindings = rest unless rest.empty?
        hash = bindings.to_hash if bindings.respond_to?(:to_hash)
        unless hash.is_a?(Hash)
          raise ArgumentError, "bindings must be a Hash-like object"
        end

        Evaluation::Evaluator.new(self, hash,
                                  mode: mode || :approximate,
                                  guard_digits: guard_digits).evaluate
      end

      # Explicit unit-aware arithmetic; callers construct Unitsml::Quantity
      # bindings. The ordinary numeric evaluate API remains independent.
      def evaluate_quantity(bindings = {})
        hash = bindings.to_hash if bindings.respond_to?(:to_hash)
        raise ArgumentError, "bindings must be a Hash-like object" unless hash.is_a?(Hash)

        Evaluation::QuantityEvaluator.new(self, hash).evaluate
      end

      def to_asciimath(formatter: nil, unitsml: {}, options: nil)
        options ||= { formatter: formatter, unitsml: unitsml }.compact
        options[:formula] ||= self
        wrap_render_error(:asciimath) do
          value.map do |val|
            val.to_asciimath(options: asciimath_table_options(options, val))
          end.join(" ")
        end
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
          unary_function_spacing: unary_function_spacing,
        }.compact
        options[:formula] ||= self
        if split_on_linebreak
          return line_breaked_mathml(display_style, intent,
                                     options: options)
        end

        wrap_render_error(:mathml) do
          # MathML 4 carries displaystyle on <math> itself, so no <mstyle>
          # wrapper is emitted (plurimath#477).
          math_attrs = {
            xmlns: "http://www.w3.org/1998/Math/MathML",
            display: "block",
            displaystyle: boolean_display_style(display_style),
          }
          math = ox_element("math", attributes: math_attrs)
          XmlHelper.update_nodes(math, mathml_content(intent, options: options))
          unitsml_post_processing(math)
          dump_nodes(math, indent: 2)
        end
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
        unless left_right_wrapper
          return mathml_content(intent,
                                options: options)
        end

        mathml_value = mathml_content(intent, options: options)
        attributes = intent_attribute(mathml_value) if intent
        mrow = ox_element("mrow", attributes: attributes)
        XmlHelper.update_nodes(mrow, mathml_value)
      end

      def mathml_content(intent, options:)
        nodes = value.map do |val|
          val.to_mathml_without_math_tag(intent, options: options)
        end
        intent_post_processing(nodes, intent) if intent
        nodes
      end

      def to_latex(formatter: nil, unitsml: {}, options: nil)
        options ||= { formatter: formatter, unitsml: unitsml }.compact
        options[:formula] ||= self
        wrap_render_error(:latex) do
          value.map { |val| val.to_latex(options: options) }.join(" ")
        end
      end

      def to_html(formatter: nil, unitsml: {}, options: nil)
        options ||= { formatter: formatter, unitsml: unitsml }.compact
        options[:formula] ||= self
        wrap_render_error(:html) do
          value&.map { |val| val.to_html(options: options) }&.join(" ")
        end
      end

      def to_omml(display_style: displaystyle, split_on_linebreak: false,
formatter: nil, unitsml: {})
        wrap_render_error(:omml) do
          objects = split_on_linebreak ? new_line_support : [self]
          options = { formatter: formatter, unitsml: unitsml }.compact
          options[:formula] ||= self
          para_element = XmlHelper.ox_element("oMathPara",
                                            attributes: OMML_NAMESPACES, namespace: "m")
          objects.each.with_index(1) do |object, index|
            para_element << XmlHelper.update_nodes(
              XmlHelper.ox_element("oMath", namespace: "m"),
              object.omml_content(boolean_display_style(display_style),
                                  options: options),
            )
            next if objects.length == index

            para_element << omml_br_tag
          end
          dump_nodes(para_element, indent: 2)
        end
      end

      def omml_content(display_style, options:)
        value&.map { |val| val.insert_t_tag(display_style, options: options) }
      end

      def to_omml_without_math_tag(display_style, options:)
        omml_content(display_style, options: options)
      end

      def to_unicodemath(formatter: nil, unitsml: {}, options: nil)
        options ||= { formatter: formatter, unitsml: unitsml }.compact
        options[:formula] ||= self
        wrap_render_error(:unicodemath) do
          Utility.html_entity_to_unicode(unicodemath_value(options: options)).gsub(
            /\s\/\s/, "/"
          )
        end
      end

      def to_display(type = nil, formatter: nil, unitsml: {},
unary_function_spacing: true, tree: :display)
        Formula.include(DisplayTreeMethods) unless Formula < DisplayTreeMethods
        super
      end

      def to_asciimath_math_zone(spacing = "", last = false, indent = true,
options:)
        Formula.include(DisplayTreeMethods) unless Formula < DisplayTreeMethods
        super
      end

      def to_latex_math_zone(spacing = "", last = false, indent = true,
options:)
        Formula.include(DisplayTreeMethods) unless Formula < DisplayTreeMethods
        super
      end

      def to_mathml_math_zone(spacing = "", last = false, indent = true,
options:)
        Formula.include(DisplayTreeMethods) unless Formula < DisplayTreeMethods
        super
      end

      def to_omml_math_zone(spacing = "", last = false, indent = true,
display_style:, options:)
        Formula.include(DisplayTreeMethods) unless Formula < DisplayTreeMethods
        super
      end

      def to_unicodemath_math_zone(spacing = "", last = false, indent = true,
options:)
        Formula.include(DisplayTreeMethods) unless Formula < DisplayTreeMethods
        super
      end

      def extract_class_name_from_text
        return unless value.length < 2 && value.first.is_a?(Function::Text)

        value.first.parameter_one
      end

      def nary_attr_value(options:)
        value.first.nary_attr_value(options: Hash.new(options))
      end

      def validate_function_formula
        value.none?(Function::Left) || value.none?(Function::Right)
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
        line_breaking(new_obj)
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

      # Attributes start
      def mathcolor=(value)
        return if value.nil? || value.empty?

        update(
          [
            Math::Function::Color.new(
              Math::Function::Text.new(value),
              filter_values(@value, array_to_instance: true),
            ),
          ],
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
            ),
          ],
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
            ),
          ],
        )
      end

      # Render this formula to a binary image string via the optional `lasem`
      # gem (https://github.com/plurimath/lasem-ruby).
      #
      # +format+ is the output image format, one of :svg, :png, :pdf, :ps.
      #
      # Remaining keyword options are split between the two stages:
      #   * to_mathml options (forwarded to #to_mathml): :intent, :formatter,
      #     :unitsml, :split_on_linebreak, :display_style,
      #     :unary_function_spacing. When :display_style is omitted the
      #     formula's own displaystyle is used.
      #   * lasem geometry options (forwarded to the renderer): :ppi, :zoom,
      #     :width, :height, :offset_x, :offset_y. Omit them for lasem defaults.
      # Unrecognized keyword options are ignored.
      #
      # Raises a Plurimath::Errors rendering error (RenderingUnavailable,
      # UnsupportedRenderFormat, or RenderingFailed) when lasem / its native
      # extension is unavailable, the format is unsupported, or rendering fails.
      # A malformed formula surfaces as Plurimath::Math::ParseError from
      # #to_mathml, not as a rendering error. Note: :split_on_linebreak emits
      # multiple <math> roots,
      # which lasem cannot render as a single document.
      def render(format: :svg, **opts)
        mathml = to_mathml(**opts.slice(*Renderer::MATHML_OPTIONS).compact)
        Renderer.render(
          mathml,
          format: format,
          **opts.slice(*Renderer::LASEM_OPTIONS),
        )
      end
      # Attributes end

      protected

      def asciimath_table_options(options, object)
        return options unless options.key?(:table) && object.is_a?(Math::Symbols::Comma)

        options.merge(literal_comma: true)
      end

      def boolean_display_style(display_style = displaystyle)
        display_style.to_s == "true"
      end

      def new_space(spacing, indent)
        if value.any? { |val| val.class_name == "left" } && value.any? do |val|
          val.class_name == "right"
        end
          return spacing
        end

        indent && wrapable?(spacing) ? "#{spacing}|_ " : spacing
      end

      def wrapable?(spacing)
        left_right_wrapper && !spacing.end_with?("|_ ")
      end

      def parse_error!(type)
        raise ParseError.new(input_string, type)
      end

      def wrap_render_error(type)
        yield
      rescue ParseError
        raise
      rescue StandardError
        parse_error!(type)
      end

      def omml_br_tag
        r_tag = ox_element("r", namespace: "m")
        r_tag << ox_element("br")
      end

      def unitsml_post_processing(math)
        if all_unitsml_nodes?(math)
          math.nodes.first.remove_attr("unitsml")
        elsif math.nodes.none?(String)
          unitsml_processing(math.nodes, math)
        end
      end

      def all_unitsml_nodes?(node)
        return false unless node.nodes.one?

        node.nodes.first["unitsml"] == "true"
      end

      # Elements whose children are positional arguments (base, script,
      # numerator, ...). A spacer added as a sibling here would add an
      # argument and break the MathML grammar, so it goes inside the unit.
      FIXED_ARITY_ELEMENTS = %w[
        msub msup msubsup mfrac mroot munder mover munderover mmultiscripts
      ].freeze

      def unitsml_processing(nodes, prev_node)
        insert_index = 0
        nodes.each.with_index do |node, index|
          if node[:unitsml]
            if FIXED_ARITY_ELEMENTS.include?(prev_node.name)
              node.insert_in_nodes(0, space_element) if node.name == "mrow"
            else
              prev_node.insert_in_nodes(index + insert_index, space_element)
              insert_index += 1
            end
            node.remove_attr("unitsml")
          end
          unitsml_processing(node.nodes, node) if node.nodes.none?(String)
        end
      end

      def space_element
        element = (ox_element("mo") << "&#x2062;")
        element[:rspace] = Symbols::Symbol::THICK_RSPACE
        element
      end

      def negated_value?
        value.last.is_a?(Math::Symbols::Symbol) && value.last.value == "&#x338;"
      end

      def unicodemath_value(options:)
        join_str = " " if !(negated_value? || mini_sized?)
        value&.map { |v| v.to_unicodemath(options: options) }&.join(join_str)
      end

      # Keep ordinary conversion independent of the optional intent stage.
      # Include on Formula (rather than self.class) so subclass super calls
      # keep the same method lookup order.
      def intent_attribute(mathml)
        Formula.include(IntentProcessing) unless Formula < IntentProcessing
        super
      end

      def intent_post_processing(nodes, _intent)
        Formula.include(IntentProcessing) unless Formula < IntentProcessing
        super
      end

      def type_error!(type)
        raise Math::InvalidTypeError.new(type)
      end
    end
  end
end
