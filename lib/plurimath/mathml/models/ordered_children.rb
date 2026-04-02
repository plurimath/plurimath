# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      module OrderedChildren
        def ordered_children
          return [] unless element_order&.any?

          indices = Hash.new(0)

          element_order.each_with_object([]) do |entry, result|
            if entry.element?
              attr_name = "#{entry.name}_value"
              next unless respond_to?(attr_name)

              collection = Array(send(attr_name))
              idx = indices[attr_name]
              if idx < collection.length
                result << collection[idx]
                indices[attr_name] = idx + 1
              end
            elsif entry.text?
              result << entry.text_content if entry.text_content
            end
          end
        end

        def children_to_plurimath
          ordered_children.filter_map do |child|
            if child.respond_to?(:to_plurimath)
              child.to_plurimath
            elsif child.is_a?(String)
              next if child.empty?

              resolve_text(child)
            end
          end
        end

        private

        def resolve_text(text)
          return nil if text.nil? || text.empty?

          Plurimath::Utility.mathml_unary_classes(
            [text],
            lang: :mathml,
          )
        end

        def extract_options(keys)
          opts = {}
          keys.each do |key|
            val = respond_to?(key) ? send(key) : nil
            opts[key] = val unless val.nil? || val.to_s.empty?
          end
          opts.empty? ? nil : opts
        end

        def resolve_symbol(value, mml_node = nil)
          return nil if value.nil? || value.empty?

          instance = Plurimath::Utility.mathml_unary_classes(
            [value],
            lang: :mathml,
          )

          if mml_node && instance.is_a?(Math::Symbols::Symbol)
            opts = build_symbol_options(mml_node)
            instance.options = opts if opts&.any?
          end

          apply_font_style(instance, mml_node)
        end

        def apply_font_style(instance, mml_node)
          return instance unless mml_node.respond_to?(:mathvariant)
          variant = mml_node.mathvariant
          return instance if variant.nil? || variant.empty?

          font_class = Plurimath::Utility::FONT_STYLES[variant.to_sym]
          return instance unless font_class

          font_class.new(instance, variant)
        end

        def build_symbol_options(mml_node)
          opts = {}
          if mml_node.respond_to?(:rspace) && mml_node.rspace
            opts[:rspace] = mml_node.rspace
          end
          opts.empty? ? nil : opts
        end

        def filter_child(value)
          return nil if value.nil?
          return value unless value.is_a?(Math::Formula)
          return value if value.value.nil? || value.value.empty?

          if value.value.length == 1
            value.value.first
          else
            value
          end
        end

        def wrap_children(children)
          case children.length
          when 0 then nil
          when 1 then children.first
          else Math::Formula.new(children)
          end
        end

        def nary_check(children)
          return children unless children.length == 2

          first = children.first
          second = children.last

          if first.is_a?(Math::Function::PowerBase) && first.parameter_one&.is_nary_symbol?
            [Math::Function::Nary.new(
              first.parameter_one,
              first.parameter_two,
              first.parameter_three,
              second,
            )]
          elsif first.is_a?(Math::Function::Overset) && first.parameter_two&.is_nary_symbol?
            [Math::Function::Nary.new(
              first.parameter_two,
              nil,
              first.parameter_one,
              second,
              { type: "undOvr" },
            )]
          elsif first.is_a?(Math::Function::Power) && first.parameter_one&.is_nary_symbol?
            [Math::Function::Nary.new(
              first.parameter_one,
              nil,
              first.parameter_two,
              second,
              { type: "subSup" },
            )]
          else
            children
          end
        end

        def fill_ternary_third_values(values)
          return unless values.is_a?(Array) && values.length > 1

          first = values.first
          if first.is_a?(Math::Function::Nary)
            first.parameter_four ||= values.delete_at(1)
          elsif first.respond_to?(:is_nary_function?) && first.is_nary_function? &&
                !first.all_values_exist?
            if first.respond_to?(:new_nary_function) && !first.any_value_exist?
              values[0] = first.new_nary_function(values.delete_at(1))
            elsif first.any_value_exist?
              first.parameter_three = values.delete_at(1)
            end
          elsif value_is_ternary_or_nary?(values)
            first.parameter_three = values.delete_at(1)
          end
        end

        def value_is_ternary_or_nary?(value)
          return if value.any?(String)

          value.length >= 2 &&
            value.first.is_ternary_function? &&
            value.first.parameter_three.nil? &&
            (!value.first.parameter_one.nil? || !value.first.parameter_two.nil?)
        end

        def ternary_naryable?(value)
          value.length == 2 &&
            value.first.is_a?(Math::Function::PowerBase) &&
            value.first.parameter_one.is_nary_symbol?
        end

        def overset_naryable?(value)
          value.length == 2 &&
            value.first.is_a?(Math::Function::Overset) &&
            value.first.parameter_two.is_nary_symbol?
        end

        def power_naryable?(value)
          value.length == 2 &&
            value.first.is_a?(Math::Function::Power) &&
            value.first.parameter_one.is_nary_symbol?
        end
      end
    end
  end
end
