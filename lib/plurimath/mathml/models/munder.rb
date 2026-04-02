# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Munder < Mml::V4::Munder
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath
          base = children[0]
          decoration = children[1]
          opts = accentunder == "true" ? { accentunder: true } : nil

          # Vec or empty ternary: fill parameter_one
          if base.is_a?(Math::Function::Vec) ||
             (base.respond_to?(:is_ternary_function?) &&
              base.is_ternary_function? && !base.any_value_exist?)
            base.parameter_one = decoration
            base.attributes = opts if opts && base.respond_to?(:attributes=)
            return base
          end

          # Empty binary function (inf, lim, etc.): fill parameter_one
          if base.respond_to?(:is_binary_function?) &&
             base.is_binary_function? && !base.any_value_exist?
            base.parameter_one = decoration
            return base
          end

          case decoration&.class_name
          when "obrace", "ubrace", "ul", "underline"
            decoration.parameter_one = base
            decoration
          when "bar"
            Math::Function::Ul.new(base, opts)
          else
            Math::Function::Underset.new(decoration, base, options: opts)
          end
        end
      end
      Models.register_model(Munder, id: :munder)
    end
  end
end
