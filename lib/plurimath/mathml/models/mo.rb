# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mo < Mml::V4::Mo
        include OrderedChildren

        def to_plurimath
          instance = resolve_symbol(value, self)

          # Handle empty Mo with attributes (e.g., <mo rspace="-0.35em"/>)
          if instance.nil? && value.nil?
            instance = Math::Symbols::Symbol.new(nil)
            opts = build_symbol_options(self)
            instance.options = opts if opts&.any?
          end

          return instance unless instance

          if linebreak && !linebreak.empty?
            lb = Math::Function::Linebreak.new(instance, { linebreak: linebreak })
            if linebreakstyle && !linebreakstyle.empty?
              lb.attributes[:linebreakstyle] = linebreakstyle
            end
            return lb
          end

          instance
        end
      end
      Models.register_model(Mo, id: :mo)
    end
  end
end
