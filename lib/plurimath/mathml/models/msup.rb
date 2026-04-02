# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Msup < Mml::V4::Msup
        include OrderedChildren

        def to_plurimath
          children = structural_children
          base = filter_child(children[0])
          sup = filter_child(children[1])

          if base&.is_binary_function? && !base.any_value_exist?
            base.parameter_one = sup
            return base
          end

          Math::Function::Power.new(base, sup)
        end

        private

        # Preserve nil positions for structural elements where order matters.
        # Skips non-content elements (malignmark, maligngroup) but keeps nils
        # from empty token elements (empty <mi/>, <mn/>, etc.)
        def structural_children
          ordered_children.each_with_object([]) do |child, result|
            next if non_content_element?(child)

            if child.respond_to?(:to_plurimath)
              result << child.to_plurimath
            elsif child.is_a?(String) && !child.empty?
              result << resolve_text(child)
            end
          end
        end

        def non_content_element?(child)
          child.is_a?(Mml::V4::Malignmark) || child.is_a?(Mml::V4::Maligngroup) ||
            child.is_a?(Mml::V3::Malignmark) || child.is_a?(Mml::V3::Maligngroup)
        end
      end
      Models.register_model(Msup, id: :msup)
    end
  end
end
