# frozen_string_literal: true

module Plurimath
  class Latex
    # LaTeX-specific helpers extracted from Plurimath::Utility (code-quality
    # refactor). Subclasses Utility so bareword `Utility.<generic>` calls inside
    # LaTeX files keep resolving here and inherit the generic helpers.
    class Utility < Plurimath::Utility
      class << self
        def organize_table(array, column_align: nil, options: nil)
          table = []
          table_data = []
          table_row = []
          organize_options(array, column_align) if options
          string_columns = column_align&.map { |column| column.is_a?(Math::Symbols::Paren) ? "|" : column.value }
          array.each do |data|
            if data&.separate_table
              table_row << Math::Function::Td.new(filter_table_data(table_data).compact)
              table_data = []
              if data.linebreak?
                organize_tds(table_row.flatten, string_columns.dup, options)
                table << Math::Function::Tr.new(table_row)
                table_row = []
              end
              next
            end
            table_data << data
          end
          # A trailing linebreak has already flushed its row and nothing follows
          # it, so there is no final cell to add. An empty input has flushed
          # nothing, and still yields its one placeholder cell.
          flushed_by_trailing_linebreak =
            table_data.empty? && table_row.empty? && !table.empty?
          unless flushed_by_trailing_linebreak
            table_row << Math::Function::Td.new(table_data.compact)
          end
          unless table_row.nil? || table_row.empty?
            organize_tds(table_row.flatten, string_columns.dup, options)
            table << Math::Function::Tr.new(table_row)
          end
          unless column_align.nil? || column_align.empty?
            table_separator(string_columns, table,
                            symbol: "|")
          end
          table
        end

        def organize_options(table_data, column_align)
          return column_align if column_align.length <= 1

          align = [column_align&.shift]
          table_data.insert(0, *column_align)
          align
        end

        def table_options(table_data)
          rowline = ""
          table_data.each do |tr|
            rowline += hline_row?(tr) ? "solid " : "none "
          end
          options = { rowline: rowline.strip } if rowline.include?("solid")
          options || {}
        end

        def organize_tds(tr_array, column_align, options)
          return tr_array if column_align.nil? || column_align.empty?

          column_align.reject! { |string| string == "|" }
          column_align = column_align * tr_array.length if options
          tr_array.map.with_index do |td, ind|
            columnalign = Plurimath::Utility::ALIGNMENT_LETTERS[column_align[ind]&.to_sym]
            td.parameter_two = { columnalign: columnalign } if columnalign
          end
        end

        def filter_table_data(table_data)
          table_data.each_with_index do |object, ind|
            if object.is_a?(Math::Symbols::Minus)
              table_data[ind] = Math::Formula.new(
                [object, table_data.delete_at(ind.next)],
              )
            end
          end
          table_data
        end

        def table_td(object)
          new_object = case object
                       when Math::Function::Td
                         object
                       else
                         Math::Function::Td.new([object].compact)
                       end
          Array(new_object)
        end

        def left_right_objects(paren, function)
          paren = if paren.to_s.match?(/\\\{|\\\}/)
                    paren.to_s.gsub("\\", "")
                  else
                    Latex::Constants::LEFT_RIGHT_PARENTHESIS[paren.to_sym]
                  end
          get_class(function).new(paren)
        end

        private

        # True when the row's first cell holds an Hline marker (a horizontal
        # rule), reached through the tr -> first cell -> first content nesting.
        def hline_row?(row)
          first_cell = row&.parameter_one&.first
          first_content = first_cell&.parameter_one&.first
          first_content.is_a?(Math::Symbols::Hline)
        end
      end
    end
  end
end
