# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mover < Mml::V4::Mover
        include OrderedChildren

        def to_plurimath
          children = children_to_plurimath
          base = filter_child(children[0])
          decoration = filter_child(children[1])
          opts = {}
          opts[:accent] = true if accent == "true"

          case decoration&.class_name
          when "obrace", "ubrace"
            decoration.parameter_one = base
            decoration
          when "hat", "ddot"
            decoration.parameter_one = base
            decoration.attributes = opts if decoration.respond_to?(:attributes=)
            decoration
          when "period", "dot"
            new_el = decoration.is_a?(Math::Symbols::Period) ? Math::Function::Dot.new : decoration
            new_el.parameter_one = base
            new_el.attributes = opts if new_el.respond_to?(:attributes=)
            new_el
          when "bar"
            decoration.parameter_one = base
            decoration
          when "vec"
            decoration.parameter_one = base
            decoration.attributes = opts if decoration.respond_to?(:attributes=)
            decoration
          when "ul", "underline"
            Math::Function::Bar.new(base, opts)
          when "tilde"
            decoration.parameter_one = base
            decoration.attributes = opts if decoration.respond_to?(:attributes=)
            decoration
          else
            Math::Function::Overset.new(decoration, base, opts)
          end
        end
      end
      Models.register_model(Mover, id: :mover)
    end
  end
end
