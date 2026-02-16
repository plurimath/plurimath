# frozen_string_literal: true

module Plurimath
  module Formatter
    module Numbers
      class Integer
        attr_reader :separator, :groups

        DEFAULT_BASE = 10
        DEFAULT_GROUPS = 3
        DEFAULT_STRINGS = {
          empty: "",
          zero: "0",
          comma: ",",
        }.freeze
        DEFAULT_BASE_PREFIXES = {
          2 => "0b",
          8 => "0o",
          16 => "0x",
        }.freeze

        def initialize(symbols = {})
          @groups    = Array(symbols[:group_digits] || DEFAULT_GROUPS)
          @separator = symbols[:group] || DEFAULT_STRINGS[:comma]
          @base = symbols[:base] || DEFAULT_BASE
          @hex_capital = symbols[:hex_capital] || false
          @base_prefix = symbols.fetch(:base_prefix, DEFAULT_BASE_PREFIXES[@base])
          @base_postfix = symbols[:base_postfix]
          @base_postfix_exists = symbols.key?(:base_postfix)
        end

        def apply(number, options = {})
          return number if groups.empty?

          formatted_number = format_groups(number_to_base(number))
          formatted_number.upcase! if upcase_hex?
          return "#{formatted_number}#{@base_postfix}" if @base_postfix_exists

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
          @base == DEFAULT_BASE
        end

        def upcase_hex?
          @hex_capital && @base == 16
        end
      end
    end
  end
end
