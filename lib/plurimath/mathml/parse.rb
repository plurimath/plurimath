# frozen_string_literal: true

require "parslet"
module Plurimath
  class Mathml
    class Parse < Parslet::Parser
      rule(:parse_record) do
        array_to_expression(Constants::CLASSES, String).as(:class) |
          array_to_expression(Constants::UNICODE_SYMBOLS.keys, Symbol).as(:symbol) |
          array_to_expression(Constants::SYMBOLS.keys, Symbol).as(:symbol) |
          match["a-zA-Z"].as(:text) |
          match(/[0-9]/).repeat(1).as(:number) |
          str("")
      end

      rule(:tag) { (parse_tag(:open) >> iteration.as(:iteration) >> parse_tag(:close)).as(:tag) | parse_text_tag.as(:tag) }

      rule(:sequence) { (tag >> sequence.as(:sequence)) | tag }

      rule(:iteration) { (sequence >> iteration.as(:iteration)) | parse_record }

      rule(:expression) { parse_tag(:open) >> iteration.as(:iteration) >> parse_tag(:close) }

      root :expression

      def array_to_expression(array, type, name = nil)
        array.reduce do |expr, tag|
          expr = str_to_expression(expr, name) if expr.is_a?(type)
          expr | str_to_expression(tag, name)
        end
      end

      def str_to_expression(string, name)
        return str(string) if name.nil?

        str(string).as(name)
      end

      def parse_tag(opts)
        tag = str("<")
        tag = tag >> str("/") if opts == :close
        tag = tag >> array_to_expression(Constants::TAGS, Symbol, opts)
        tag = tag >> attributes.as(:attributes) if opts == :open
        tag >> str(">")
      end

      def attributes
        (match["a-zA-Z"].repeat.as(:name) >>
          str("=") >> quoted_string).repeat
      end

      def quoted_string
        (str('"') >> match("[^\"]").repeat.as(:value) >> str('"')) |
          (str("'") >> match("[^\']").repeat.as(:value) >> str("'"))
      end

      def parse_text_tag
        str("<mtext>") >> match("[^<]").repeat.as(:quoted_text) >> str("</mtext>")
      end
    end
  end
end
