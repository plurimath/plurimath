# frozen_string_literal: true

module Plurimath
  class Html
    class Parse < Parsanol::Parser
      rule(:space)   { match["\s"].repeat(1) }
      rule(:unary)   { array_to_expression(Constants::UNARY_CLASSES, :unary) }
      rule(:binary)  { str("lim").as(:binary) }
      rule(:linebreak) { parse_void_tag("br").as(:linebreak) }
      rule(:sub_tag) { parse_sub_sup_tags("sub") }
      rule(:sup_tag) { parse_sub_sup_tags("sup") }

      rule(:mod) do
        wrapped_tag(str("mod").as(:binary)) |
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
        wrapped_tag(lparen) |
          lparen
      end

      rule(:close_paren) do
        wrapped_tag(rparen) |
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
        wrapped_tag(unary) |
          unary
      end

      rule(:binary_functions) do
        wrapped_tag(binary) |
          binary
      end

      rule(:parse_classes) do
        unary_functions |
          binary_functions
      end

      rule(:symbol_text_or_tag) do
        tag_parse |
          html_entity.as(:symbol) |
          (match["0-9"].repeat(1) >> decimal_marker >> match["0-9"].repeat(1)).as(:number) |
          match["0-9"].repeat(1).as(:number) |
          match["a-zA-Z"].as(:text) |
          match["^0-9a-zA-Z<>(){}\\[\\]\s"].as(:symbol)
      end

      rule(:intermediate_exp) do
        (sub_sup.as(:sub_sup) >> sub_sup_tags) |
          (symbol_text_or_tag.as(:sub_sup) >> sub_sup_tags) |
          sub_sup |
          parse_classes |
          linebreak |
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
          # Formula has no header-cell node; HTML <th> is parsed as Td.
          parse_sub_sup_tags(%w[td th], "td") |
          wrapped_tag(sequence.as(:sequence))
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

      def decimal_marker
        str(Plurimath.configuration.decimal)
      end

      def parse_tag(opts, tag_name = nil, capture_name: nil)
        tag = str("<")
        tag = tag >> str("/") if opts == :close
        name_expression = html_tag_name(tag_name)
        name_expression = name_expression.capture(capture_name) if capture_name
        tag = tag >> name_expression
        tag = tag >> tag_attributes if opts == :open
        tag >> str(">")
      end

      def parse_void_tag(tag_name)
        str("<") >> html_tag_name(tag_name) >> tag_attributes >> str(">")
      end

      def html_entity
        (str("&#x") >> match["0-9a-fA-F"].repeat(1) >> str(";")) |
          (str("&#") >> match["0-9"].repeat(1) >> str(";")) |
          (str("&") >> match["a-zA-Z"] >> match["a-zA-Z0-9"].repeat >> str(";"))
      end

      def parse_sub_sup_tags(tag_names, transform_name = tag_names)
        Array(tag_names).map do |tag_name|
          parse_tag(:open, tag_name) >>
            sequence.as(:"#{transform_name}_value") >>
            parse_tag(:close, tag_name)
        end.reduce(:|)
      end

      def wrapped_tag(expression)
        scope do
          parse_tag(:open, capture_name: :html_tag_name) >>
            expression >>
            matching_close_tag
        end
      end

      def matching_close_tag
        dynamic do |_source, context|
          parse_tag(:close, context.captures[:html_tag_name].to_s)
        end
      end

      def html_tag_name(tag_name)
        return match["a-zA-Z"] >> match["a-zA-Z0-9:._-"].repeat unless tag_name

        case_insensitive_string(tag_name) >> tag_name_boundary
      end

      def tag_name_boundary
        match["\\s/>"].present?
      end

      def tag_attributes
        (quoted_attribute_value | match["^<>"]).repeat
      end

      def quoted_attribute_value
        (str('"') >> match['^"'].repeat >> str('"')) |
          (str("'") >> match["^'"].repeat >> str("'"))
      end

      def case_insensitive_string(value)
        value.chars
          .map { |char| char.match?(/[A-Za-z]/) ? match["#{char.downcase}#{char.upcase}"] : str(char) }
          .reduce(:>>)
      end
    end
  end
end
