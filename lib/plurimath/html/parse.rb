# frozen_string_literal: true

require "parslet"
module Plurimath
  class Html
    class Parse < Parslet::Parser
      rule(:space)   { match["\s"].repeat(1) }
      rule(:unary)   { array_to_expression(Constants::UNARY_CLASSES, :unary) }
      rule(:binary)  { str("lim").as(:binary) }
      rule(:sub_tag) { parse_sub_sup_tags("sub") }
      rule(:sup_tag) { parse_sub_sup_tags("sup") }

      rule(:mod) do
        (parse_tag(:open) >> str("mod").as(:binary) >> parse_tag(:close)) |
          str("mod").as(:binary)
      end

      rule(:lparen) do
        array_to_expression(Constants::PARENTHESIS.keys, :lparen)
      end

      rule(:rparen) do
        array_to_expression(Constants::PARENTHESIS.values, :rparen)
      end

      rule(:sub_sup) do
        array_to_expression(Constants::SUB_SUP_CLASSES.keys, :sum_prod)
      end

      rule(:open_paren) do
        (parse_tag(:open) >> lparen >> parse_tag(:close)) |
          lparen
      end

      rule(:close_paren) do
        (parse_tag(:open) >> rparen >> parse_tag(:close)) |
          rparen
      end

      rule(:sub_sup_tags) do
        (sub_tag >> sup_tag) |
          (sup_tag >> sub_tag) |
          sup_tag |
          sub_tag
      end

      rule(:unary_args) do
        (unary_functions >> parse_parenthesis.as(:first_value)).as(:unary_function) |
          (unary_functions >> intermediate_exp.as(:first_value)).as(:unary_function) |
          (unary_functions >> sequence.as(:first_value)).as(:unary_function)
      end

      rule(:binary_args) do
        (binary_functions >> parse_parenthesis.as(:first_value) >> parse_parenthesis.as(:second_value)) |
          (binary_functions >> parse_parenthesis.as(:first_value)) |
          (binary_functions >> intermediate_exp.as(:first_value) >> intermediate_exp.as(:second_value)) |
          (binary_functions >> intermediate_exp.as(:first_value))
      end

      rule(:unary_functions) do
        (parse_tag(:open) >> unary >> parse_tag(:close)) |
          unary
      end

      rule(:binary_functions) do
        (parse_tag(:open) >> binary >> parse_tag(:close)) |
          binary
      end

      rule(:parse_classes) do
        unary_functions |
          binary_functions
      end

      rule(:symbol_text_or_tag) do
        tag_parse |
          (str("&") >> match["a-zA-Z0-9"].repeat(2) >> str(";")).as(:symbol) |
          (match["0-9"].repeat(1) >> str(".") >> match["0-9"].repeat(1)).as(:number) |
          match["0-9"].repeat(1).as(:number) |
          match["a-zA-Z"].as(:text) |
          match["^0-9a-zA-Z<>/(){}\\[\\]\s"].as(:symbol)
      end

      rule(:intermediate_exp) do
        (sub_sup.as(:sub_sup) >> sub_sup_tags) |
          (symbol_text_or_tag.as(:sub_sup) >> sub_sup_tags) |
          sub_sup |
          parse_classes |
          symbol_text_or_tag |
          space
      end

      rule(:parse_parenthesis) do
        (open_paren >> symbol_text_or_tag >> close_paren) |
          (open_paren >> intermediate_exp >> close_paren) |
          (open_paren >> expression >> close_paren)
      end

      rule(:sequence) do
        parse_parenthesis.as(:parse_parenthesis) |
          (unary_args >> sequence.as(:sequence)) |
          (binary_args >> sequence.as(:sequence)) |
          unary_args |
          binary_args |
          (symbol_text_or_tag >> parse_parenthesis.as(:parse_parenthesis)) |
          (intermediate_exp >> expression.as(:expression)) |
          intermediate_exp
      end

      rule(:tag_parse) do
        parse_sub_sup_tags("table") |
          parse_sub_sup_tags("tr") |
          parse_sub_sup_tags("td") |
          (parse_tag(:open) >> sequence.as(:sequence) >> parse_tag(:close))
      end

      rule(:expression) do
        (intermediate_exp.as(:first_value) >> mod >> intermediate_exp.as(:second_value)) |
          (parse_classes.as(:sub_sup) >> sub_sup_tags) |
          (sequence.as(:sequence) >> sequence.as(:expression)) |
          sequence
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

      def parse_tag(opts)
        tag = str("<")
        tag = tag >> str("/") if opts == :close
        tag = tag >> match(/\w+/).repeat
        tag >> str(">")
      end

      def parse_sub_sup_tags(tag)
        str("<#{tag}>") >> sequence.as(:"#{tag}_value") >> str("</#{tag}>")
      end
    end
  end
end
