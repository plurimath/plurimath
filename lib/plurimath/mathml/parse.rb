# frozen_string_literal: true

require "parslet"
module Plurimath
  class Mathml
    class Parse < Parslet::Parser
      rule(:parse_record) do
        parse_class.as(:class) |
          parse_symbols.as(:symbol) |
          match["a-zA-Z"].as(:text) |
          match(/[0-9]/).repeat(1).as(:number) |
          str("")
      end

      rule(:tag) { (parse_tag(:open) >> iteration.as(:iteration) >> parse_tag(:close)).as(:tag) | parse_text_tag.as(:tag) }

      rule(:sequence) { (tag >> sequence.as(:sequence)) | tag }

      rule(:iteration) { (sequence >> iteration.as(:iteration)) | parse_record }

      rule(:expression) { parse_tag(:open) >> iteration.as(:iteration) >> parse_tag(:close) }

      root :expression

      def parse_class
        Constants::CLASSES.reduce do |expr, tag|
          expr = str(expr) if expr.is_a?(String)
          expr | str(tag)
        end
      end

      def parse_symbols
        Constants::UNICODE_SYMBOLS.keys.reduce do |expr, tag|
          expr = str(expr) if expr.is_a?(Symbol)
          expr | str(tag)
        end
      end

      def parse_tag(opts)
        tag = str("<")
        tag = tag >> str("/") if opts == :close
        tag = tag >> tags(opts)
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

      def tags(value)
        Constants::TAGS.reduce do |expr, tag|
          expr = str(expr).as(value) if expr.is_a?(Symbol)
          expr | str(tag).as(value)
        end
      end

      def parse_text_tag
        str("<mtext>") >> match("[^<]").repeat.as(:quoted_text) >> str("</mtext>")
      end
    end
  end
end
