# frozen_string_literal: true

module Plurimath
  module Math
    class Core < Lutaml::Model::Serializable
      REPLACABLES = {
        /&amp;/ => "&",
        /^\n/ => "",
      }.freeze

      ALL_PARAMETERS = %i[
        parameter_one
        parameter_two
        parameter_three
        parameter_four
      ].freeze

      # Discriminator for polymorphic node fields. It is computed from the
      # class name and never stored, so writers and == do not see it.
      attribute :__class, :string, polymorphic_class: true

      # Resolves a "__class" value to a node class. The map is built from
      # the class tree on demand instead of listing every node class.
      NODE_CLASS_MAP = Hash.new do |map, name|
        klass = name.is_a?(String) && name.start_with?("Plurimath::Math::") &&
          Object.const_get(name)
        map[name] = name if klass.is_a?(Class) && klass <= Core
      rescue NameError
        nil
      end

      # from_hash must not call the hand-written constructors, because some
      # of them take required arguments. lutaml-model then allocates the
      # node and sets the mapped fields only.
      def self.constructs_through_initialize?
        false
      end

      # Declares node-holding fields. Each field keeps its storage in the
      # existing instance variable. lutaml-model sees a Core-typed view of
      # it, plus a "<field>_text" key for String values and a
      # "<field>_value" key for an attribute Hash or an empty array. A field
      # that is not a collection also gets a "<field>_list" key, for the
      # nodes that keep an array of nodes in a single-node field. Every
      # mapped key must be listed here, because a key_value block replaces
      # the automatic mapping. A subclass keeps the rules it inherits and
      # adds its own.
      #
      # Fields that hold no nodes are mapped through plain methods: hashes
      # (keys keep their Symbol or String type), symbols (a Symbol is stored
      # as its name, a String as { "string" => string }, so the two stay
      # apart) and values (stored as they are).
      def self.node_fields(*fields, collections: [], scalars: {}, hashes: [],
                           symbols: [], values: [])
        fields.each { |field| declare_node_field(field, collections.include?(field)) }
        hashes.each { |field| declare_plain_field(field, :hash) }
        symbols.each { |field| declare_plain_field(field, :symbol) }
        values.each { |field| declare_plain_field(field, :value) }
        scalars.each { |name, type| attribute(name, type) }
        rules = { fields: fields, lists: fields - collections,
                  scalars: scalars.keys, plain: hashes + symbols + values }
        key_value { Core.node_field_rules(self, **rules) }
      end

      def self.node_field_rules(mapping, fields:, lists:, scalars:, plain:)
        mapping.map "__class", to: :__class
        scalars.each { |name| mapping.map name.to_s, to: name }
        plain.each do |name|
          mapping.map name.to_s, with: { to: :"#{name}_to_kv", from: :"#{name}_from_kv" }
        end
        polymorphic = { attribute: "__class", class_map: NODE_CLASS_MAP }
        fields.each do |name|
          mapping.map name.to_s, to: :"__#{name}_node", polymorphic: polymorphic
          if lists.include?(name)
            mapping.map "#{name}_list", to: :"__#{name}_nodes", polymorphic: polymorphic
          end
          mapping.map "#{name}_text", with: { to: :"#{name}_text_to_kv",
                                              from: :"#{name}_text_from_kv" }
          mapping.map "#{name}_value", with: { to: :"#{name}_value_to_kv",
                                               from: :"#{name}_value_from_kv" }
          mapping.map "#{name}_mixed", with: { to: :"#{name}_mixed_to_kv",
                                               from: :"#{name}_mixed_from_kv" }
        end
      end

      def self.declare_node_field(name, collection)
        attribute :"__#{name}_node", Core, polymorphic: true, collection: collection
        if collection
          hide_node_list(name)
        else
          declare_node_list(name)
        end
        attr_accessor name

        ivar = :"@#{name}"
        define_method(:"__#{name}_node") do
          value = instance_variable_get(ivar)
          if value.is_a?(::Array)
            value if collection && value.all?(Core)
          elsif value.is_a?(Core)
            value
          end
        end
        define_method(:"__#{name}_node=") do |value|
          instance_variable_set(ivar, value) unless value.nil?
        end
        define_method(:"#{name}_text_to_kv") do |model, doc|
          value = model.instance_variable_get(ivar)
          doc["#{name}_text"] = value if value.is_a?(String)
        end
        define_method(:"#{name}_text_from_kv") do |model, value|
          model.instance_variable_set(ivar, value)
        end
        # Some node fields hold an attribute Hash (Td's parameter_two) or an
        # empty array, which neither node view keeps.
        define_method(:"#{name}_value_to_kv") do |model, doc|
          value = model.instance_variable_get(ivar)
          if value.is_a?(::Hash)
            doc["#{name}_value"] = Core.dump_keys(value)
          elsif value == []
            doc["#{name}_value"] = []
          end
        end
        define_method(:"#{name}_value_from_kv") do |model, value|
          model.instance_variable_set(ivar, Core.load_keys(value))
        end
        declare_mixed_list(name)
      end

      # An array that mixes Strings and nodes fits neither node view nor the
      # text key, so it goes in "<field>_mixed" as a tagged list: a String
      # becomes { "text" => string } and a node { "class" => name,
      # "node" => hash }. Writers never read these keys.
      def self.declare_mixed_list(name)
        ivar = :"@#{name}"
        define_method(:"#{name}_mixed_to_kv") do |model, doc|
          value = model.instance_variable_get(ivar)
          doc["#{name}_mixed"] = Core.dump_mixed(value) if Core.mixed?(value)
        end
        define_method(:"#{name}_mixed_from_kv") do |model, value|
          model.instance_variable_set(ivar, Core.load_mixed(value)) if value.is_a?(::Array)
        end
      end

      def self.mixed?(value)
        value.is_a?(::Array) && !value.all?(Core) &&
          value.all? { |item| item.is_a?(::String) || item.is_a?(Core) }
      end

      def self.dump_mixed(value)
        value.map do |item|
          next { "text" => item } if item.is_a?(::String)

          { "class" => item.class.name, "node" => item.to_hash }
        end
      end

      def self.load_mixed(value)
        value.map do |item|
          item = item.transform_keys(&:to_s)
          next item["text"] unless item.key?("node")

          name = NODE_CLASS_MAP[item["class"]]
          raise ArgumentError, "unknown node class #{item['class'].inspect}" unless name

          Object.const_get(name).from_hash(item["node"])
        end
      end

      # The array view of a single-node field. It is empty unless the field
      # holds a non-empty array of nodes, so it never replaces a single node.
      def self.declare_node_list(name)
        attribute :"__#{name}_nodes", Core, polymorphic: true, collection: true
        ivar = :"@#{name}"
        define_method(:"__#{name}_nodes") do
          value = instance_variable_get(ivar)
          value if value.is_a?(::Array) && !value.empty? && value.all?(Core)
        end
        define_method(:"__#{name}_nodes=") do |value|
          instance_variable_set(ivar, value) if value.is_a?(::Array) && !value.empty?
        end
      end

      # A subclass that turns an inherited single-node field into a
      # collection still inherits the array view, so keep that view empty.
      def self.hide_node_list(name)
        return unless method_defined?(:"__#{name}_nodes")

        define_method(:"__#{name}_nodes") { nil }
        define_method(:"__#{name}_nodes=") { |_value| nil }
      end

      PLAIN_DUMP = {
        hash: ->(value) { Core.dump_keys(value) if value.is_a?(::Hash) },
        symbol: lambda { |value|
          case value
          when ::Symbol then value.to_s
          when ::String then { "string" => value }
          end
        },
        value: ->(value) { value },
      }.freeze

      PLAIN_LOAD = {
        hash: ->(value) { Core.load_keys(value) },
        symbol: lambda { |value|
          value.is_a?(::Hash) ? value.transform_keys(&:to_s)["string"] : value&.to_sym
        },
        value: ->(value) { value },
      }.freeze

      def self.declare_plain_field(name, kind)
        attr_accessor name

        ivar = :"@#{name}"
        dump = PLAIN_DUMP.fetch(kind)
        load = PLAIN_LOAD.fetch(kind)
        define_method(:"#{name}_to_kv") do |model, doc|
          value = dump.call(model.instance_variable_get(ivar))
          doc[name.to_s] = value unless value.nil?
        end
        define_method(:"#{name}_from_kv") do |model, value|
          model.instance_variable_set(ivar, load.call(value))
        end
      end

      # Hashes held by nodes mostly have Symbol keys. Keys are stored as
      # Strings, and the keys that were Strings are listed under
      # STRING_KEYS, so load_keys gives each key its original type back. A
      # hash with Symbol keys only is stored as before.
      STRING_KEYS = "__string_keys"

      # With stringify: false the keys are kept as they are, and only the
      # STRING_KEYS list is added, which JSON needs.
      def self.dump_keys(value, stringify: true)
        case value
        when ::Hash
          dumped = value.to_h do |key, item|
            [stringify ? key.to_s : key, dump_keys(item, stringify: stringify)]
          end
          strings = value.keys.grep(::String)
          dumped[STRING_KEYS] = strings unless strings.empty?
          dumped
        when ::Array then value.map { |item| dump_keys(item, stringify: stringify) }
        else value
        end
      end

      def self.load_keys(value)
        case value
        when ::Hash
          strings = Array(value[STRING_KEYS] || value[STRING_KEYS.to_sym]).map(&:to_s)
          value.each_with_object({}) do |(key, item), loaded|
            next if key.to_s == STRING_KEYS

            key = key.to_s
            loaded[strings.include?(key) ? key : key.to_sym] = load_keys(item)
          end
        when ::Array then value.map { |item| load_keys(item) }
        else value
        end
      end

      def __class
        self.class.name
      end

      def __class=(_value); end

      # Hand-written constructors set fields directly, so lutaml-model never
      # learns which fields were given. Treat every field as given.
      def using_default?(_attribute_name)
        false
      end

      def self.inherited(subclass)
        @descendants ||= []
        @descendants << subclass
        super
      end

      def self.descendants
        @descendants
      end

      def class_name
        self.class.name.split("::").last.downcase
      end

      def insert_t_tag(display_style, options:)
        Array(omml_nodes(display_style, options: options))
      end

      def tag_name
        "subsup"
      end

      def omml_tag_name
        "subSup"
      end

      def nary_attr_value(**)
        ""
      end

      def empty_tag(wrapper_tag = nil)
        r_tag = ox_element("r", namespace: "m")
        r_tag << (ox_element("t", namespace: "m") << "&#8203;")
        return r_tag unless wrapper_tag

        wrapper_tag << r_tag
      end

      def omml_parameter(field, display_style, tag_name:, options:,
namespace: "m")
        tag = ox_element(tag_name, namespace: namespace)
        return empty_tag(tag) unless field

        field_value = if field.is_a?(Array)
                        field.map do |object|
                          object.insert_t_tag(display_style, options: options)
                        end
                      else
                        field.insert_t_tag(display_style, options: options)
                      end
        XmlHelper.update_nodes(tag, field_value)
      end

      def validate_function_formula
        true
      end

      def r_element(string, rpr_tag: true)
        r_tag = ox_element("r", namespace: "m")
        if rpr_tag
          r_tag << (ox_element("rPr", namespace: "m") << msty_tag_with_attrs)
        end
        r_tag << (ox_element("t", namespace: "m") << string)
        Array(r_tag)
      end

      def msty_tag_with_attrs
        attrs = { "m:val": "p" }
        ox_element("sty", namespace: "m", attributes: attrs)
      end

      def extractable?
        false
      end

      def extract_class_name_from_text
        ""
      end

      def font_style_t_tag(display_style, options:)
        omml_nodes(display_style, options: options)
      end

      def ascii_fields_to_print(field, options = {})
        return if field.nil?

        hashed = common_math_zone_conversion(field, options)
        options[:array] << "#{hashed[:spacing]}|_ \"#{field&.to_asciimath(options: options[:options])}\"#{hashed[:field_name]}\n"
        return unless ModelHelper.validate_math_zone(field, lang: :asciimath)

        options[:array] << field&.to_asciimath_math_zone(
          hashed[:function_spacing], hashed[:last], hashed[:indent], options: options[:options]
        )
      end

      def latex_fields_to_print(field, options = {})
        return if field.nil?

        hashed = common_math_zone_conversion(field, options)
        options[:array] << "#{hashed[:spacing]}|_ \"#{field&.to_latex(options: options[:options])}\"#{hashed[:field_name]}\n"
        return unless ModelHelper.validate_math_zone(field, lang: :latex)

        options[:array] << field&.to_latex_math_zone(hashed[:function_spacing],
                                                     hashed[:last], hashed[:indent], options: options[:options])
      end

      def mathml_fields_to_print(field, options = {})
        return if field.nil?

        hashed = common_math_zone_conversion(field, options)
        options[:array] << "#{hashed[:spacing]}|_ \"#{dump_mathml(field,
                                                                  options: options[:options])}\"#{hashed[:field_name]}\n"
        return unless ModelHelper.validate_math_zone(field, lang: :mathml,
                                                            intent: options[:intent], options: options[:options])

        options[:array] << field&.to_mathml_math_zone(
          hashed[:function_spacing], hashed[:last], hashed[:indent], options: options[:options]
        )
      end

      def omml_fields_to_print(field, options = {})
        return if field.nil?

        hashed = common_math_zone_conversion(field, options)
        display_style = options[:display_style]
        options[:array] << "#{hashed[:spacing]}|_ \"#{dump_omml(field,
                                                                display_style, options: options[:options])}\"#{hashed[:field_name]}\n"
        return unless ModelHelper.validate_math_zone(field, lang: :omml)

        options[:array] << field&.to_omml_math_zone(hashed[:function_spacing],
                                                    hashed[:last], hashed[:indent], display_style: display_style, options: options[:options])
      end

      def unicodemath_fields_to_print(field, options = {})
        return if field.nil?

        hashed = common_math_zone_conversion(field, options)
        options[:array] << "#{hashed[:spacing]}|_ \"#{field&.to_unicodemath(options: options[:options])}\"#{hashed[:field_name]}\n"
        return unless ModelHelper.validate_math_zone(field, lang: :unicodemath)

        options[:array] << field&.to_unicodemath_math_zone(
          hashed[:function_spacing], hashed[:last], hashed[:indent], options: options[:options]
        )
      end

      def dump_mathml(field, intent = false, options:)
        dump_ox_nodes(field.mathml_nodes(intent, options: options)).gsub(
          /\n\s*/, ""
        )
      end

      def dump_omml(field, display_style, options:)
        return if field.nil?

        dump_ox_nodes(field.omml_nodes(display_style, options: options)).gsub(
          /\n\s*/, ""
        )
      end

      def mathml_nodes(intent, options:)
        to_mathml_without_math_tag(intent, options: options)
      end

      def omml_nodes(display_style, options:)
        to_omml_without_math_tag(display_style, options: options)
      end

      def validate_mathml_fields(field, intent, options:)
        if field.is_a?(Array)
          field&.map { |object| object.mathml_nodes(intent, options: options) }
        else
          field&.mathml_nodes(intent, options: options)
        end
      end

      def common_math_zone_conversion(field, options = {})
        {
          spacing: options[:spacing],
          last: options[:last] || true,
          indent: !field.is_a?(Formula),
          function_spacing: "#{options[:spacing]}#{options[:additional_space]}",
          field_name: (options[:field_name] ? " #{options[:field_name]}" : ""),
        }
      end

      def filtered_values(value, lang:, options: {})
        @values = ModelHelper.filter_math_zone_values(value, lang: lang,
                                                             options: options)
      end

      def dump_ox_nodes(nodes)
        return dump_nodes(nodes) unless nodes.is_a?(Array)

        nodes.flatten.map { |node| dump_nodes(node) }.join
      end

      def dump_nodes(nodes, indent: nil)
        replacable_values(
          Plurimath.xml_engine.dump(nodes, indent: indent),
        )
      end

      def replacable_values(string)
        REPLACABLES.each { |regex, str| string = string.gsub(regex, str) }
        string
      end

      def gsub_spacing(spacing, last)
        spacing.gsub("|_", last ? "  " : "| ")
      end

      def invert_unicode_symbols
        Mathml::Constants::UNICODE_SYMBOLS.invert[class_name] || class_name
      end

      def separate_table
        false
      end

      def linebreak?
        false
      end

      def cloned_objects
        object = self.class.new(nil)
        variables.each { |var| object.set(var, variable_value(get(var))) }
        object
      end

      def variable_value(value)
        case value
        when Core
          value.cloned_objects
        when Array
          value.map { |object| variable_value(object) }
        else
          value
        end
      end

      def line_breaking(obj)
        variables.each do |variable|
          field = get(variable)
          case field
          when Core
            field.line_breaking(obj)
            if obj.value_exist?
              updated_object_values(variable, obj: obj,
                                              update_value: true)
            end
          when Array
            array_line_break_field(field, variable, obj)
          end
        end
      end

      def updated_object_values(param, obj:, update_value: false)
        object = self.class.new(nil)
        found = false
        variables.each do |variable|
          value = if param == variable
                    found = true
                    if update_value
                      return_value = obj.value
                      obj.value = []
                      return_value
                    else
                      formula = Formula.new(get(variable))
                      formula.line_breaking(obj)
                      set(variable, obj)
                      get(variable)
                    end
                  else
                    return_value = get(variable)
                    set(variable, nil) if found
                    return_value
                  end
          object.set(variable, Utility.filter_values(value))
        end
        object.hide_function_name = true if object.methods.include?(:hide_function_name)
        obj.update(object)
      end

      def get(variable)
        instance_variable_get(variable)
      end

      def set(variable, value)
        instance_variable_set(variable, value)
      end

      def variables
        instance_variables.reject do |var|
          name = var.to_s
          name.start_with?("@__", "@lutaml") ||
            name == "@using_default"
        end
      end

      def ox_element(node, attributes: [], namespace: "")
        XmlHelper.ox_element(
          node,
          attributes: attributes,
          namespace: namespace,
        )
      end

      def result(value = [])
        value = get("@value") || value
        value.slice_after { |d| d.is_a?(Math::Function::Linebreak) }.to_a
      end

      def is_unary?
        is_a?(Math::Function::UnaryFunction)
      end

      def is_nary_function?; end

      def is_nary_symbol?; end

      def nary_intent_name; end

      def symbol?
        is_a?(Math::Symbols::Symbol)
      end

      def is_binary_function?
        is_a?(Function::BinaryFunction)
      end

      def is_ternary_function?
        is_a?(Function::TernaryFunction)
      end

      def mini_sized?
        false
      end

      def plus_operator?
        false
      end

      def minus_operator?
        false
      end

      def multiply_operator?
        false
      end

      def divide_operator?
        false
      end

      def power_operator?
        false
      end

      def operator?
        plus_operator? || minus_operator? || multiply_operator? ||
          divide_operator? || power_operator?
      end

      def reserved_constant
        nil
      end

      # Default evaluation entry point: a node that does not implement a
      # numeric evaluation raises UnsupportedExpressionError. Concrete nodes
      # (Number, Symbol operators, Function::*) override this.
      def evaluate(evaluator)
        evaluator.unsupported(self)
      end

      def open?
        false
      end

      def close?
        false
      end

      # The bound variable a node represents, or nil if it is not a plain
      # variable. Symbols and text nodes that name a variable override this;
      # it lets iteration indexes accept both `Symbols::Symbol` (AsciiMath/
      # MathML) and `Function::Text` (OMML) without type-sniffing.
      def variable_name
        nil
      end

      def unicodemath_parens(field, options:)
        paren = field.to_unicodemath(options: options)
        return paren if field.is_a?(Math::Function::Fenced)

        "(#{paren})" if field
      end

      def prime_unicode?(field)
        return false unless field.is_a?(Math::Symbols::Symbol)
        return true if field&.value&.include?("&#x27;")

        Utility.primes_constants.any? do |_prefix, prime|
          unicodemath_field_value(field).include?(prime)
        end
      end

      def paren?
        false
      end

      def pretty_print_instance_variables
        excluded_vars = %i[
          @left_right_wrapper
          @using_default
          @displaystyle
          @__encoding
          @__register
          @__ordered
          @unitsml
          @__mixed
          @is_mrow
          @values
        ]
        instance_variables.sort - excluded_vars
      end

      def to_ms_value
        new_arr = []
        case self
        when Math::Symbols::Symbol
          new_arr << (value ? value.to_s : to_unicodemath(options: {}))
        when Math::Number, Math::Function::Text
          new_arr << value
        else
          parameters_to_ms_value(new_arr)
          if respond_to?(:value) && value.is_a?(Array)
            new_arr << value&.map(&:to_ms_value)&.join(" ")
          end
        end
        new_arr
      end

      def is_mstyle?
        false
      end

      def is_mrow?
        false
      end

      private

      def parameters_to_ms_value(array)
        ALL_PARAMETERS.each do |field|
          array << get("@#{field}")&.to_ms_value if respond_to?(field)
        end
      end

      def array_line_break_field(field, variable, obj)
        if result(field).length > 1
          updated_object_values(variable, obj: obj)
        else
          field.each { |object| object.line_breaking(obj) }
        end
      end

      def unicodemath_field_value(field)
        field.class_name == "symbol" ? field.value : Utility.hexcode_in_input(field)
      end

      def wrap_mrow(xml_engine_node, intent)
        return xml_engine_node if xml_engine_node.name == "mrow"
        return xml_engine_node unless intent

        ox_element("mrow") << xml_engine_node
      end

      def intentify(tag, intent, func_name:, intent_name: nil, options: {})
        return tag unless intent

        Utility::IntentEncoding.send("#{func_name}_intent", tag, intent_name,
                                     options)
      end

      def masked_tag(tag)
        options_array = get_mask_options
        if options_array.include?("show_up_limit_place_holder") && parameter_three.nil?
          set_place_holder(tag, type: :above)
        end
        if options_array.include?("show_low_limit_place_holder") && parameter_two.nil?
          set_place_holder(tag, type: :below)
        end
        if options_array.include?("limits_opposite")
          change_power_base_values(tag)
        end
        if options_array.include?("limits_under_over")
          case tag.name
          when "msubsup" then tag.name = "munderover"
          when "msub" then tag.name = "munder"
          when "msup" then tag.name = "mover"
          end
        elsif options_array.include?("limits_sub_sup")
          case tag.name
          when "munderover" then tag.name = "msubsup"
          when "munder" then tag.name = "msub"
          when "mover" then tag.name = "msup"
          end
        elsif options_array.include?("upper_limit_as_super_script") && tag.nodes[1].name == "mrow"
          tag = XmlHelper.update_nodes(
            ox_element("munder"),
            [
              XmlHelper.update_nodes(
                ox_element("msup"),
                [
                  tag.nodes[0],
                  tag.nodes[2],
                ],
              ),
              tag.nodes[1],
            ],
          )
        end
        tag
      end

      def get_mask_options(mask_options = [])
        mask = options&.dig(:mask).to_i

        case mask % 4
        when 0 then mask_options << "limits_default"
        when 1 then mask_options << "limits_under_over"
        when 2 then mask_options << "limits_sub_sup"
        when 3 then mask_options << "upper_limit_as_super_script"
        end

        mask -= mask % 4

        case mask % 32
        when 4 then mask_options << "limits_opposite"
        when 8 then mask_options << "show_low_limit_place_holder"
        when 12 then mask_options += ["limits_opposite",
                                      "show_low_limit_place_holder"]
        when 16 then mask_options << "show_up_limit_place_holder"
        when 20 then mask_options += ["limits_opposite",
                                      "show_up_limit_place_holder"]
        when 24 then mask_options += ["show_low_limit_place_holder",
                                      "show_up_limit_place_holder"]
        when 28 then mask_options += ["limits_opposite",
                                      "show_low_limit_place_holder", "show_up_limit_place_holder"]
        end

        mask_options
      end

      def change_power_base_values(tag)
        return unless ["munderover", "msubsup"].include?(tag.name)

        Plurimath.xml_engine.replace_nodes(
          tag,
          [tag.nodes[0], tag.nodes[2], tag.nodes[1]],
        )
      end

      def set_place_holder(node, type:)
        nodes = if type == :below
                  node.name = node.name == "msup" ? "msubsup" : "munderover"
                  node.nodes.insert(1, mo_tag("&#x2b1a;"))
                else
                  node.name = node.name == "msub" ? "msubsup" : "munderover"
                  node.nodes.insert(2, mo_tag("&#x2b1a;"))
                end
        Plurimath.xml_engine.replace_nodes(node, nodes)
      end

      def mo_tag(str)
        ox_element("mo") << str
      end

      # HTML for the base of a script: italic, except an upright (FontStyle::Normal)
      # base, which is how units are written in the other formats.
      def html_base(base, options)
        html = base.to_html(options: options)
        base.is_a?(Function::FontStyle::Normal) ? html : "<i>#{html}</i>"
      end
    end
  end
end
