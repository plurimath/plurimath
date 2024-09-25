# frozen_string_literal: true

require_relative "../../utility"
require_relative "../../utility/shared"
module Plurimath
  class Utility
    module Latex
      class TransformHelper < Utility
        extend Shared::Constants
        extend Shared::LatexAndMathml

        class << self
          def organize_table(array, column_align: nil, options: nil)
            table = []
            table_data = []
            table_row = []
            organize_options(array, column_align) if options
            string_columns = column_align&.map { |column| column.paren? ? "|" : column.value }
            array.each do |data|
              if data&.separate_table
                table_row << Math::Function::Td.new(filter_table_data(table_data).compact)
                table_data = []
                if data.linebreak
                  organize_tds(table_row.flatten, string_columns.dup, options)
                  table << Math::Function::Tr.new(table_row)
                  table_row = []
                end
                next
              end
              table_data << data
            end
            table_row << Math::Function::Td.new(table_data.compact) if table_data
            unless table_row.nil? || table_row.empty?
              organize_tds(table_row.flatten, string_columns.dup, options)
              table << Math::Function::Tr.new(table_row)
            end
            table_separator(string_columns, table, symbol: "|") unless column_align.nil? || column_align.empty?
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
              if tr&.parameter_one&.first&.parameter_one&.first.is_a?(Math::Symbols::Hline)
                rowline += "solid "
              else
                rowline += "none "
              end
            end
            options = { rowline: rowline.strip } if rowline.include?("solid")
            options || {}
          end

          def organize_tds(tr_array, column_align, options)
            return tr_array if column_align.nil? || column_align.empty?

            column_align.reject! { |string| string == "|" }
            column_align = column_align * tr_array.length if options
            tr_array.each_with_index do |td, ind|
              columnalign = ALIGNMENT_LETTERS[column_align[ind]&.to_sym]
              td.parameter_two = { columnalign: columnalign } if columnalign
            end
          end

          def filter_table_data(table_data)
            return table_data unless table_data.any?(Math::Symbols::Minus)

            table_data.each_with_index do |object, ind|
              next unless object.is_a?(Math::Symbols::Minus)

              table_data[ind] = Math::Formula.new(
                [object, table_data.delete_at(ind.next)],
              )
            end
            table_data
          end

          def left_right_objects(paren, function)
            paren = if paren.to_s.match?(/\\\{|\\\}/)
                      paren.to_s.gsub(/\\/, "")
                    else
                      Plurimath::Latex::Constants::LEFT_RIGHT_PARENTHESIS[paren.to_sym]
                    end
            get_class(function).new(paren)
          end
        end
      end
    end
  end
end
