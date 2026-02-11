# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class Integer
        attr_reader :separator, :groups

        BASE_NUMBER_SYSTEMS = {
          2 => "Binary",
          8 => "Octal",
          10 => "Decimal",
          16 => "Hexadecimal",
        }.freeze
        
        BASE_PREFIXES = {
          2 => "0b",
          8 => "0o",
          16 => "0x",
        }.freeze
        
        BASE_POSTFIXES = {
          2 => "",
          8 => "",
          16 => "",
        }.freeze

        def initialize(symbols = {})
          @groups    = Array(symbols[:group_digits] || 3)
          @separator = symbols[:group] || ','
          @base = symbols[:base] || 10
          @hex_capital = symbols[:hex_capital] || false
          @base_prefix = symbols.fetch(:base_prefix, BASE_PREFIXES[@base])
          @base_postfix = symbols[:base_postfix]
        end

        def apply(number, options = {})
          return number if groups.empty?

          formatted_number = format_groups(number_to_base(number))
          formatted_number.upcase! if upcase_hex?
          return "#{formatted_number}#{@base_postfix}" if options.key?(:base_postfix)

          "#{@base_prefix}#{formatted_number}"
        end

        def format_groups(string)
          tokens = []

          tokens << chop_group(string, groups.first)
          string = string[0...-tokens.first.size]

          until string.empty?
            tokens << chop_group(string, groups.last)
            string = string[0...-tokens.last.size]
          end

          tokens.compact.reverse.join(separator)
        end

        def chop_group(string, size)
          string.slice([string.size - size, 0].max, size)
        end

        def number_to_base(number)
          return number if base_default?

          number.to_i.to_s(@base)
        end

        def base_default?
          @base == 10
        end

        def upcase_hex?
          @hex_capital && @base == 16
        end
      end
    end
  end
end
