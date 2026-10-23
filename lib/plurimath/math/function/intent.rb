# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Intent < BinaryFunction
        def to_mathml_without_math_tag(intent, options:)
          first_value = parameter_one.to_mathml_without_math_tag(intent,
                                                                 options: options)
          first_value.attributes["intent"] = encoded_intent(first_value)
          first_value
        end

        # The intent string is metadata, not content: OMML has no slot for it,
        # so only the wrapped content is written. The inherited BinaryFunction
        # rendering wrapped both parameters in an <m:r>, nesting runs (invalid
        # OMML) and printing the intent text as a visible run.
        def to_omml_without_math_tag(display_style, options:)
          return [] unless parameter_one

          parameter_one.insert_t_tag(display_style, options: options)
        end

        # Same leak as OMML: the inherited rendering printed the intent text.
        def to_html(options:)
          "<i>#{parameter_one.to_html(options: options)}</i>" if parameter_one
        end

        def to_unicodemath(options:)
          first_value = "(#{parameter_two.to_unicodemath(options: options)}#{parameter_one.to_unicodemath(options: options)})" if parameter_one || parameter_two
          "ⓘ#{first_value}"
        end

        def intent_names
          { name: ":derivative" }
        end

        private

        def encoded_intent(tag)
          if parameter_two.value == intent_names[:name] && encodable?
            field = parameter_one.value
            unicode = encode(field[0].parameter_one.value)
            unfenced_str = fence_value(tag.nodes[1].nodes[1..-2]) if tag.nodes[1]["intent"] == ":fenced"
            fenced_str = "(#{unfenced_str})" unless unfenced_str.empty?
            "#{intent_names[:name]}(1,#{unicode}#{fenced_str},#{unfenced_str})"
          else
            Utility.html_entity_to_unicode(parameter_two.value)
          end
        end

        def encodable?
          return false unless parameter_one.is_a?(Formula)

          field = parameter_one.value[0]
          field.is_a?(Power) &&
            prime_unicode?(field.parameter_two) &&
            field.parameter_one.is_a?(Symbols::Symbol)
        end

        def fence_value(nodes)
          str = ""
          nodes.each do |node|
            break unless node.name == "mi"

            str += encode(node.nodes.first)
          end
          str
        end

        def encode(str)
          Utility.html_entity_to_unicode(str)
        end
      end
    end
  end
end
