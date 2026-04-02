# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mmultiscripts < Mml::V4::Mmultiscripts
        include OrderedChildren

        def to_plurimath
          children = multiscript_children
          parts = multiscript_parts(children)
          Math::Function::Multiscript.new(
            parts[0],
            Array(parts[1])&.first,
            Array(parts[1])&.last,
          )
        end

        private

        def multiscript_children
          ordered_children.filter_map do |child|
            if child.is_a?(Mml::V4::Mprescripts) || child.is_a?(Mml::V3::Mprescripts)
              "mprescripts"
            elsif child.is_a?(Mml::V4::None) || child.is_a?(Mml::V3::None)
              Math::Function::None.new
            elsif child.respond_to?(:to_plurimath)
              # In mmultiscripts, empty tokens (e.g., <mi/>) act as None
              child.to_plurimath || Math::Function::None.new
            elsif child.is_a?(String)
              next if child.empty?

              resolve_text(child)
            end
          end
        end

        def multiscript_parts(children)
          children.slice_before { |c| c.to_s.include?("mprescripts") }.map do |group|
            base_value = group.shift
            group = Plurimath::Utility.nil_to_none_object(group)
            parts = group.partition.with_index { |_, i| i.even? }
            subs = parts[0].empty? ? nil : parts[0]
            sups = parts[1].empty? ? nil : parts[1]

            if base_value.to_s.include?("mprescripts")
              [subs, sups]
            else
              Math::Function::PowerBase.new(
                filter_child(base_value),
                unwrap_single(subs),
                unwrap_single(sups),
              )
            end
          end
        end

        def unwrap_single(value)
          return nil if value.nil? || (value.is_a?(Array) && value.empty?)
          return value unless value.is_a?(Array)

          value.length == 1 ? value.first : Math::Formula.new(value)
        end
      end
      Models.register_model(Mmultiscripts, id: :mmultiscripts)
    end
  end
end
