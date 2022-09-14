# frozen_string_literal: true

require "parslet"
module Plurimath
  class Omml
    class Parse < Parslet::Parser
      rule(:sequence)  { (iteration >> iteration) | iteration }
      rule(:iteration) { (expression >> expression) | expression | number_text }

      rule(:open_sub_sup)  { parse_tag(:open, Constants::SUB_SUP_TAG) }
      rule(:close_sub_sup) { parse_tag(:close, Constants::SUB_SUP_TAG) }

      rule(:attributes) do
        (attribute.as(:name) >> str("=") >> quoted_string).repeat
      end

      rule(:sub_sup_tags) do
        (open_sub_sup >> tag.as(:fonts) >> sub_sup_values >> close_sub_sup)
      end

      rule(:attribute) do
        (match["a-zA-Z"].repeat >> str(":") >> match["a-zA-Z0-9"].repeat) |
          match["a-zA-Z0-9"].repeat
      end

      rule(:number_text) do
        match["0-9"].repeat(1).as(:number) |
          match["a-zA-Z"].as(:text).repeat |
          match("[^a-zA-Z]")
      end

      rule(:tag) do
        omission_tag |
          (parse_tag(:open) >> sequence.as(:iteration) >> parse_tag(:close)) |
          (parse_tag(:open) >> parse_tag(:close))
      end

      rule(:sub_sup_values) do
        (tag.as(:first_value) >> tag.as(:second_value) >> tag.as(:third_value)) |
          (tag.as(:first_value) >> tag.as(:second_value)) |
          tag.as(:first_value)
      end

      rule(:expression) do
        sub_sup_tags |
          (tag >> sequence.as(:sequence)) |
          tag
      end

      root :expression

      def array_to_expression(array, name = nil)
        initial_type = array.first.class
        array.reduce do |expr, tag|
          expr = str_to_expression(expr, name) if expr.is_a?(initial_type)
          expr | str_to_expression(tag, name)
        end
      end

      def str_to_expression(string, name)
        return str(string) if name.nil?

        str(string).as(name)
      end

      def quoted_string
        (str('"') >> match("[^\"]").repeat.as(:value) >> str('"')) |
          (str("'") >> match("[^\']").repeat.as(:value) >> str("'"))
      end

      def omission_tag
        tag = str("<w:") | str("<m:")
        tag = tag >> array_to_expression(Constants::TAGS, :omission)
        tag = tag >> attributes.as(:attributes)
        tag >> str("/>")
      end

      def parse_tag(opts, tags = Constants::TAGS)
        tag = str("<w:") | str("<m:") if opts == :open
        tag = str("</w:") | str("</m:") if opts == :close
        tag = tag >> array_to_expression(tags, opts)
        tag = tag >> attributes.as(:attributes) if opts == :open
        tag >> str(">")
      end
    end
  end
end
