# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      class Mtable < Mml::V4::Mtable
        include OrderedChildren

        def to_plurimath
          rows = ordered_children.filter_map do |child|
            child.to_plurimath if child.respond_to?(:to_plurimath)
          end
          opts = extract_options(%i[
            columnalign columnlines columnspacing rowlines
            rowspacing frame framespacing rowalign width
            displaystyle side minlabelspacing
          ])

          # Apply column line separators
          if opts&.dig(:columnlines)
            separators = opts[:columnlines].split
            if separators.all? { |s| s == "none" }
              opts.delete(:columnlines)
            else
              Plurimath::Utility.table_separator(separators, rows)
            end
          end

          Math::Function::Table.new(rows, nil, nil, opts || {})
        end
      end
      Models.register_model(Mtable, id: :mtable)
    end
  end
end
