# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      # A measured value with its uncertainty (plurimath#493).
      #
      # Three categories are supported: a standard uncertainty (JCGM 100
      # 7.2.1, 7.2.2), a symmetric expanded uncertainty with its coverage
      # factor (JCGM 100 6.2.1, 7.2.3) and a coverage interval given by its
      # endpoints (JCGM 101 5.3, 5.5). The node records the reported numbers
      # exactly as written; it never calculates, rounds or converts them.
      # See docs/uncertainty.adoc.
      class Uncertainty < Core
        CATEGORIES = %i[standard expanded coverage_interval].freeze
        NOTATIONS = %i[absolute concise].freeze
        INTERVAL_KINDS = %i[shortest probabilistically_symmetric].freeze

        SIGNED_DECIMAL = /\A-?[0-9]+(\.[0-9]+)?\z/
        UNSIGNED_DECIMAL = /\A[0-9]+(\.[0-9]+)?\z/

        MARKER_NAMES = {
          standard: "standard-uncertainty",
          expanded: "expanded-uncertainty",
          coverage_interval: "coverage-interval",
        }.freeze

        ASCIIMATH_NAMES = {
          standard: "ustd",
          expanded: "uexp",
          coverage_interval: "ucov",
        }.freeze

        INTERVAL_KIND_NAMES = {
          shortest: "shortest",
          probabilistically_symmetric: "probabilistically-symmetric",
        }.freeze

        # AsciiMath reads "-" as minus, so the symmetric kind has its own spelling.
        ASCIIMATH_INTERVAL_KIND_NAMES = {
          shortest: "shortest",
          probabilistically_symmetric: "symmetric",
        }.freeze

        PLUS_MINUS = "&#xb1;"

        # One unit symbol as UnitsML writes it, for example "kg".
        UNIT_SYMBOL = /\A[A-Za-z]+\z/

        attr_reader :value, :category, :magnitude, :coverage_factor,
                    :coverage_probability, :lower, :upper, :interval_kind,
                    :notation, :unit

        # The keyword list is the documented model (docs/uncertainty.adoc).
        def initialize( # rubocop:disable Metrics/ParameterLists
          value,
          category:,
          magnitude: nil,
          coverage_factor: nil,
          coverage_probability: nil,
          lower: nil,
          upper: nil,
          interval_kind: nil,
          notation: :absolute,
          unit: nil
        )
          @value = value
          @category = category
          @magnitude = magnitude
          @coverage_factor = coverage_factor
          @coverage_probability = coverage_probability
          @lower = lower
          @upper = upper
          @interval_kind = interval_kind
          @notation = category == :standard ? notation : nil
          @unit = unit
          super()
          validate!(notation)
        end

        def ==(other)
          other.class == self.class &&
            other.category == category &&
            other.value == value &&
            other.magnitude == magnitude &&
            other.coverage_factor == coverage_factor &&
            other.coverage_probability == coverage_probability &&
            other.lower == lower &&
            other.upper == upper &&
            other.interval_kind == interval_kind &&
            other.notation == notation &&
            other.unit == unit
        end

        # Core#cloned_objects builds `self.class.new(nil)`, which the
        # validating constructor rejects, so rebuild through the constructor.
        def cloned_objects
          self.class.new(
            value.cloned_objects,
            category: category,
            magnitude: magnitude&.cloned_objects,
            coverage_factor: coverage_factor&.cloned_objects,
            coverage_probability: coverage_probability&.cloned_objects,
            lower: lower&.cloned_objects,
            upper: upper&.cloned_objects,
            interval_kind: interval_kind,
            notation: notation || :absolute,
            unit: unit&.cloned_objects,
          )
        end

        # The node is one indivisible result; never split it across lines.
        def line_breaking(_obj); end

        # The marker string carried by MathML intent, the OMML phantom and
        # the UnicodeMath intent form.
        def marker
          name = MARKER_NAMES[category]
          name = "#{name}:concise" if notation == :concise
          if interval_kind
            name = "#{name}:#{INTERVAL_KIND_NAMES[interval_kind]}"
          end
          "#{name}(#{marker_arguments.join(',')})"
        end

        def concise_digits
          digits = text(magnitude).delete(".").sub(/\A0+/, "")
          digits.empty? ? "0" : digits
        end

        # Output

        def to_asciimath(options:)
          args = case category
                 when :standard
                   if notation == :concise
                     ["#{text(value)}(#{concise_digits})"]
                   else
                     [text(value), text(magnitude)]
                   end
                 when :expanded
                   [text(value), text(magnitude), text(coverage_factor),
                    text(coverage_probability)]
                 else
                   [text(value), text(lower), text(upper),
                    text(coverage_probability),
                    ASCIIMATH_INTERVAL_KIND_NAMES[interval_kind]]
                 end
          unitsml = asciimath_unitsml if unit
          args << "\"unitsml(#{unitsml})\"" if unitsml
          call = "#{ASCIIMATH_NAMES[category]}(#{args.compact.join(', ')})"
          return call if unit.nil? || unitsml

          # Not expressible in UnitsML: keep it visible after the call, the
          # only place the AsciiMath reader accepts it (docs/uncertainty.adoc).
          "#{call} #{unit.to_asciimath(options: options)}"
        end

        def to_latex(options:)
          unit_text = " #{unit.to_latex(options: options)}" if unit
          case category
          when :standard
            "#{text(value)}(#{standard_parenthesised})#{unit_text}"
          when :expanded
            "(#{text(value)} \\pm #{text(magnitude)})#{unit_text}#{latex_statements}"
          else
            interval = "[#{text(lower)}, #{text(upper)}]"
            "#{text(value)},\\ #{interval}#{unit_text}#{latex_statements}"
          end
        end

        def to_html(options:)
          unit_text = " #{unit.to_html(options: options)}" if unit
          case category
          when :standard
            "#{text(value)}(#{standard_parenthesised})#{unit_text}"
          when :expanded
            "(#{text(value)} #{PLUS_MINUS} #{text(magnitude)})#{unit_text}#{text_statements}"
          else
            interval = "[#{text(lower)}, #{text(upper)}]"
            "#{text(value)}, #{interval}#{unit_text}#{text_statements}"
          end
        end

        def to_unicodemath(options:)
          unit_text = "ⓐ(unit #{unit.to_unicodemath(options: options)})" if unit
          visible = case category
                    when :standard
                      "#{unicodemath_value}(#{standard_parenthesised})#{unit_text}"
                    when :expanded
                      "(#{text(value)}±#{text(magnitude)})#{unit_text}#{unicodemath_statements}"
                    else
                      interval = "[#{text(lower)}, #{text(upper)}]"
                      "#{unicodemath_value}, #{interval}#{unit_text}#{unicodemath_statements}"
                    end
          "ⓘ(\"#{marker}\"#{visible})"
        end

        def to_mathml_without_math_tag(intent, options:)
          nodes = case category
                  when :standard
                    [
                      mn_tag(text(value)),
                      mathml_fence("(", ")", [mn_tag(standard_parenthesised)]),
                    ]
                  when :expanded
                    [
                      mathml_fence(
                        "(", ")",
                        [mn_tag(text(value)), mo_tag(PLUS_MINUS),
                         mn_tag(text(magnitude))]
                      ),
                    ]
                  else
                    [
                      mn_tag(text(value)),
                      mo_tag(","),
                      mathml_fence(
                        "[", "]",
                        [mn_tag(text(lower)), mo_tag(","),
                         mn_tag(text(upper))]
                      ),
                    ]
                  end
          nodes << mathml_unit(intent, options) if unit
          nodes.concat(mathml_statements)
          mrow = ox_element("mrow", attributes: { intent: marker })
          XmlHelper.update_nodes(mrow, nodes)
        end

        def to_omml_without_math_tag(display_style, options:)
          nodes = [omml_marker]
          nodes.concat(
            case category
            when :standard
              [
                omml_run(text(value)),
                omml_fence("(", ")", [omml_run(standard_parenthesised)]),
              ]
            when :expanded
              [
                omml_fence(
                  "(", ")",
                  [omml_run(text(value)), omml_run(PLUS_MINUS),
                   omml_run(text(magnitude))]
                ),
              ]
            else
              [
                omml_run(text(value)),
                omml_run(","),
                omml_fence(
                  "[", "]",
                  [omml_run(text(lower)), omml_run(","),
                   omml_run(text(upper))]
                ),
              ]
            end,
          )
          nodes << omml_box(unit.insert_t_tag(display_style, options: options)) if unit
          nodes.concat(statements.flat_map { |name, number| omml_statement(name, number) })
          [omml_box(nodes)]
        end

        def to_asciimath_math_zone(spacing = "", _last = false, _indent = true,
                                   options:)
          "#{spacing}\"#{to_asciimath(options: options)}\" uncertainty\n"
        end

        def to_latex_math_zone(spacing = "", _last = false, _indent = true,
                               options:)
          "#{spacing}\"#{to_latex(options: options)}\" uncertainty\n"
        end

        def to_mathml_math_zone(spacing = "", _last = false, _indent = true,
                                options:)
          "#{spacing}\"#{dump_mathml(self, options: options)}\" uncertainty\n"
        end

        def to_omml_math_zone(spacing = "", _last = false, _indent = true,
                              display_style:, options:)
          "#{spacing}\"#{dump_omml(self, display_style,
                                   options: options)}\" uncertainty\n"
        end

        def to_unicodemath_math_zone(spacing = "", _last = false,
                                     _indent = true, options:)
          "#{spacing}\"#{to_unicodemath(options: options)}\" uncertainty\n"
        end

        private

        def text(number)
          number&.value
        end

        def standard_parenthesised
          notation == :concise ? concise_digits : text(magnitude)
        end

        def marker_arguments
          args = case category
                 when :standard
                   [text(value), text(magnitude)]
                 when :expanded
                   [text(value), text(magnitude), text(coverage_factor),
                    text(coverage_probability)]
                 else
                   [text(value), text(lower), text(upper),
                    text(coverage_probability)]
                 end
          args << "$unit" if unit
          args.compact
        end

        # The ", k = 2" and ", p = 0.95" statements, in order.
        def statements
          list = []
          list << ["k", coverage_factor] if coverage_factor
          list << ["p", coverage_probability] if coverage_probability
          list
        end

        def latex_statements
          statements.map { |name, number| ",\\ #{name} = #{text(number)}" }.join
        end

        def text_statements
          statements.map { |name, number| ", #{name} = #{text(number)}" }.join
        end

        def unicodemath_statements
          statements.map { |name, number| ", #{name}=#{text(number)}" }.join
        end

        # The UnicodeMath reader cannot take `"marker"-...`, so a negative
        # leading value goes in an invisible 〖〗 group; the marker is unchanged.
        def unicodemath_value
          text(value).start_with?("-") ? "〖#{text(value)}〗" : text(value)
        end

        # The UnitsML text for the AsciiMath unit argument, or nil when the
        # unit cannot be written as UnitsML. A unit read from markup is its
        # rendered Formula; it is written back as UnitsML only when it is a
        # `*`-separated product of upright unit symbols with optional integer
        # powers, and UnitsML renders that text back to the same product.
        def asciimath_unitsml
          return unit.text if unit.is_a?(Unitsml)

          candidate = unit_text(unit)
          return unless candidate

          candidate if unit_text(::Unitsml.parse(candidate).to_plurimath({})) == candidate
        rescue *unitsml_parse_errors
          nil
        end

        # UnitsML raised Parslet::ParseFailed for text it cannot read until
        # 0.6.10, and Parsanol::ParseFailed since it moved to Parsanol.
        def unitsml_parse_errors
          [Parslet::ParseFailed,
           (::Parsanol::ParseFailed if defined?(::Parsanol::ParseFailed))].compact
        end

        def unit_text(node)
          case node
          when Math::Formula then unit_product(node.value)
          when Power then unit_power(node)
          else unit_symbol(node)
          end
        end

        def unit_product(parts)
          return if parts.empty? || parts.length.even?

          texts = parts.each_with_index.map do |part, index|
            if index.odd?
              part.is_a?(Math::Symbols::Cdot) ? "*" : nil
            else
              unit_text(part)
            end
          end
          texts.join unless texts.include?(nil)
        end

        def unit_power(node)
          base = unit_symbol(node.parameter_one)
          exponent = node.parameter_two
          exponent = exponent.value if exponent.is_a?(Math::Formula)
          exponent = Array(exponent)
          sign = ""
          if exponent.length == 2 && exponent.first.is_a?(Math::Symbols::Minus)
            sign = "-"
            exponent = exponent.drop(1)
          end
          number = exponent.first
          return unless base && exponent.length == 1 &&
            number.is_a?(Math::Number) && number.value.to_s.match?(/\A[0-9]+\z/)

          "#{base}^#{sign}#{number.value}"
        end

        def unit_symbol(node)
          node = node.parameter_one if node.is_a?(FontStyle::Normal)
          string = case node
                   when Text then node.parameter_one
                   when Math::Symbols::Symbol
                     node.value if node.instance_of?(Math::Symbols::Symbol)
                   end
          string if string.is_a?(String) && string.match?(UNIT_SYMBOL)
        end

        # MathML helpers

        def mn_tag(string)
          ox_element("mn") << string
        end

        def mi_tag(string)
          ox_element("mi") << string
        end

        def mathml_fence(open, close, nodes)
          XmlHelper.update_nodes(
            ox_element("mrow"),
            [mo_tag(open), *nodes, mo_tag(close)],
          )
        end

        def mathml_statements
          statements.flat_map do |name, number|
            [mo_tag(","), mi_tag(name), mo_tag("="), mn_tag(text(number))]
          end
        end

        # Unitsml marks its MathML with `unitsml`, so Formula#to_mathml puts
        # the usual unit space in front of it; a unit read from markup is
        # marked the same way.
        def mathml_unit(intent, options)
          nodes = unit.to_mathml_without_math_tag(intent, options: options)
          mrow = if !nodes.is_a?(Array) && nodes.name == "mrow"
                   nodes
                 else
                   XmlHelper.update_nodes(ox_element("mrow"), Array(nodes))
                 end
          mrow["unitsml"] = true unless mrow["unitsml"]
          mrow["arg"] = "unit"
          mrow
        end

        # OMML helpers

        def omml_run(string)
          ox_element("r", namespace: "m") << (ox_element("t", namespace: "m") << string)
        end

        def omml_box(nodes)
          box = ox_element("box", namespace: "m")
          box << XmlHelper.update_nodes(ox_element("e", namespace: "m"), nodes)
        end

        def omml_fence(open, close, nodes)
          dpr = ox_element("dPr", namespace: "m")
          dpr << ox_element("begChr", namespace: "m", attributes: { "m:val": open })
          dpr << ox_element("sepChr", namespace: "m", attributes: { "m:val": "" })
          dpr << ox_element("endChr", namespace: "m", attributes: { "m:val": close })
          d_tag = ox_element("d", namespace: "m") << dpr
          d_tag << XmlHelper.update_nodes(ox_element("e", namespace: "m"), nodes)
        end

        def omml_statement(name, number)
          [omml_run(","), omml_run(name), omml_run("="), omml_run(text(number))]
        end

        def omml_marker
          phant_pr = ox_element("phantPr", namespace: "m")
          phant_pr << ox_element("show", namespace: "m", attributes: { "m:val": "off" })
          %w[zeroWid zeroAsc zeroDesc].each do |name|
            phant_pr << ox_element(name, namespace: "m", attributes: { "m:val": "on" })
          end
          phant = ox_element("phant", namespace: "m") << phant_pr
          phant << XmlHelper.update_nodes(
            ox_element("e", namespace: "m"),
            r_element(marker),
          )
        end

        # Validation

        def validate!(notation)
          unless CATEGORIES.include?(category)
            invalid!("unknown category #{category.inspect}")
          end

          validate_number(:value, value, signed: true)
          %i[magnitude coverage_factor coverage_probability lower upper].each do |field|
            number = public_send(field)
            validate_number(field, number, signed: false) unless number.nil?
          end
          validate_unit
          send(:"validate_#{category}", notation)
        end

        def validate_standard(notation)
          forbid(:coverage_factor, :coverage_probability, :lower, :upper,
                 :interval_kind)
          require_fields(:magnitude)
          unless NOTATIONS.include?(notation)
            invalid!("unknown notation #{notation.inspect}")
          end
          return unless notation == :concise
          return if decimal_places(text(magnitude)) == decimal_places(text(value))

          invalid!(
            "magnitude #{text(magnitude)} cannot be written concisely after " \
            "#{text(value)}: it needs as many decimal places as the value",
          )
        end

        def validate_expanded(notation)
          forbid(:lower, :upper, :interval_kind)
          validate_unqualified_notation(notation)
          require_fields(:magnitude, :coverage_factor)
          validate_coverage_factor
          validate_coverage_probability
        end

        def validate_coverage_interval(notation)
          forbid(:magnitude, :coverage_factor)
          validate_unqualified_notation(notation)
          require_fields(:lower, :upper, :coverage_probability)
          unless interval_kind.nil? || INTERVAL_KINDS.include?(interval_kind)
            invalid!("unknown interval kind #{interval_kind.inspect}")
          end
          validate_coverage_probability
          return if compare_decimals(text(lower), text(upper)).negative?

          invalid!("lower endpoint #{text(lower)} is not below upper endpoint #{text(upper)}")
        end

        def validate_unqualified_notation(notation)
          return if notation.nil? || notation == :absolute

          invalid!("notation #{notation.inspect} applies only to a standard uncertainty")
        end

        def validate_coverage_factor
          return if positive?(text(coverage_factor))

          invalid!("coverage factor #{text(coverage_factor)} must be greater than 0")
        end

        def validate_coverage_probability
          return if coverage_probability.nil?

          probability = text(coverage_probability)
          return if positive?(probability) && compare_decimals(probability, "1").negative?

          invalid!("coverage probability #{probability} must lie strictly between 0 and 1")
        end

        def validate_number(field, number, signed:)
          pattern = signed ? SIGNED_DECIMAL : UNSIGNED_DECIMAL
          kind = signed ? "decimal" : "unsigned decimal"
          valid = number.is_a?(Math::Number) &&
            number.value.is_a?(String) &&
            number.value.match?(pattern) &&
            !number.mini_sized? &&
            number.base.nil?
          return if valid

          invalid!(
            "#{field} must be a Math::Number holding a plain #{kind}, " \
            "got #{number.inspect}",
          )
        end

        def validate_unit
          return if unit.nil? || unit.is_a?(Unitsml)

          unless unit.is_a?(Math::Formula)
            invalid!("unit must be a Math::Function::Unitsml, got #{unit.inspect}")
          end
          invalid!("unit must not be empty") if empty_formula?(unit)
          return unless holds_uncertainty?(unit)

          invalid!("unit must not contain an uncertainty")
        end

        def empty_formula?(formula)
          Array(formula.value).compact.all? do |part|
            part.is_a?(Math::Formula) && empty_formula?(part)
          end
        end

        def holds_uncertainty?(node)
          case node
          when Uncertainty then true
          when Array then node.any? { |item| holds_uncertainty?(item) }
          when Math::Core
            node.instance_variables.any? do |name|
              holds_uncertainty?(node.instance_variable_get(name))
            end
          else false
          end
        end

        def forbid(*fields)
          fields.each do |field|
            next if public_send(field).nil?

            invalid!("#{field} does not apply to a #{category} uncertainty")
          end
        end

        def require_fields(*fields)
          fields.each do |field|
            next unless public_send(field).nil?

            invalid!("#{field} is required for a #{category} uncertainty")
          end
        end

        def invalid!(message)
          raise Errors::InvalidUncertainty.new(message)
        end

        def decimal_places(string)
          string.include?(".") ? string.split(".", 2).last.length : 0
        end

        def positive?(string)
          string.match?(/[1-9]/)
        end

        # Exact comparison of two unsigned plain decimals, without Float.
        def compare_decimals(first, second)
          first_int, first_frac = first.split(".", 2)
          second_int, second_frac = second.split(".", 2)
          first_int = first_int.sub(/\A0+/, "")
          second_int = second_int.sub(/\A0+/, "")
          by_length = first_int.length <=> second_int.length
          return by_length unless by_length.zero?

          width = [first_frac.to_s.length, second_frac.to_s.length].max
          "#{first_int}#{first_frac.to_s.ljust(width, '0')}" <=>
            "#{second_int}#{second_frac.to_s.ljust(width, '0')}"
        end
      end
    end
  end
end
