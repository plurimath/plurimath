# frozen_string_literal: true

module Plurimath
  module Math
    class Formula
      # The stored model composition, independent of language rendering and its
      # filtering. Only model content fields are visited; formatting options,
      # source text, XML objects and rendering caches are deliberately omitted.
      class ClassTree
        UNCERTAINTY_FIELDS = %i[
          value category magnitude coverage_factor coverage_probability lower
          upper interval_kind notation unit
        ].freeze

        def render(formula)
          lines = []
          append(formula, nil, 0, lines, {})
          lines.join("\n")
        end

        private

        def append(object, label, depth, lines, ancestors)
          prefix = "#{'  ' * depth}#{"#{label}: " if label}"
          unless object.is_a?(Core) || object.is_a?(::Array)
            lines << "#{prefix}#{literal(object)}"
            return
          end

          if ancestors.key?(object.object_id)
            lines << "#{prefix}<cycle: #{object.class.name}>"
            return
          end

          ancestors[object.object_id] = true
          begin
            if object.is_a?(::Array)
              append_array(object, label, depth, lines, ancestors)
            else
              lines << "#{prefix}#{object.class.name}"
              fields(object).each do |field|
                append(object.public_send(field), field, depth + 1,
                       lines, ancestors)
              end
            end
          ensure
            ancestors.delete(object.object_id)
          end
        end

        def append_array(array, label, depth, lines, ancestors)
          if array.empty?
            lines << "#{'  ' * depth}#{label}: []"
          else
            array.each_with_index do |child, index|
              append(child, "#{label}[#{index}]", depth, lines, ancestors)
            end
          end
        end

        def fields(object)
          case object
          when Function::Table
            %i[value open_paren close_paren]
          when Function::Uncertainty
            UNCERTAINTY_FIELDS
          else
            parameters = Core::ALL_PARAMETERS.select do |field|
              object.respond_to?(field)
            end
            return parameters unless parameters.empty?
            return [:value] if object.respond_to?(:value)
            return [:text] if object.respond_to?(:text)

            []
          end
        end

        def literal(object)
          case object
          when String, ::Symbol, Numeric, true, false, nil
            object.inspect
          else
            # Never delegate to arbitrary #inspect: that can expose internal
            # state or memory addresses in otherwise deterministic output.
            "<#{object.class.name}>"
          end
        end
      end
    end
  end
end
