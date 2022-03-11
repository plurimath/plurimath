# frozen_string_literal: true

require_relative "constants"
module Plurimath
  class Asciimath
    class Parser
      attr_accessor :text

      def initialize(text)
        @text = text
        @symbols = Constants::SYMBOLS_AND_CLASSES.keys
        lookahead = @symbols.map(&:length).max
        @symbol_regexp = /((?:\\[\s0-9]|[^\s0-9]){1,#{lookahead}})/
      end

      def parse
        create_nodes
        formula = Plurimath::Math::Formula.new
        while current_node = @nodes.first
          formula.value << intermediate_parse(current_node)
        end
        formula
      end

      def intermediate_parse(current_node, ind = 0)
        return if current_node.nil?

        @nodes.delete_at(ind)
        formula = Plurimath::Math::Formula.new
        if function?(current_node)
          function_parse(current_node, formula)
        else
          node_object = current_node&.first&.last.new(current_node&.first&.first)
          node_object = mod_function_parse(node_object) if @nodes&.first&.first&.first == "mod"
          node_object
        end
      end

      def function_parse(current_node, formula)
        if Constants::PARENTHESES.key?(@nodes&.first&.first&.first)
          parse_until_closing_parenthesis(formula)
        end
        parse_number(formula)
        finalize_node(current_node, formula)
      end

      def parse_number(formula)
        if number?
          current_node = @nodes.delete_at(0)
          formula.value << current_node.first&.last.new(current_node.first&.first)
        end
      end

      def finalize_node(current_node, formula)
        functions_arr = ["frac", "color", "mod", "overset", "root", "underset"]
        node_class = current_node&.first&.last
        if ["sum", "prod", "log"].include?(current_node&.first&.first)
          exponent_parser(formula)
          current_node&.first&.last.new(base_parser, exponent_parser, formula)
        elsif functions_arr.include?(current_node&.first&.first)
          node_class.new(formula, dual_param_function)
        else
          text_or_symbol_class(current_node, formula)
        end
      end

      def text_or_symbol_class(current_node, formula)
        node_class = current_node&.first&.last
        if text?(current_node)
          node_class.new(current_node&.first&.first)
        else
          node_class.new(formula)
        end
      end

      def dual_param_function
        return nil if @nodes&.first&.nil?

        formula = Plurimath::Math::Formula.new
        if Constants::PARENTHESES.key?(@nodes&.first&.first&.first)
          parse_until_closing_parenthesis(formula)
        else
          return if Constants::PARENTHESES.value?(@nodes&.first&.first&.first)

          formula.value << intermediate_parse(@nodes.first)
        end
        formula
      end

      def exponent_parser(formula = Plurimath::Math::Formula.new)
        if @nodes.first&.key?("^")
          @nodes.delete_at(0)
          if Constants::PARENTHESES.key?(@nodes&.first&.first&.first)
            parse_until_closing_parenthesis(formula)
          else
            formula.value << intermediate_parse(@nodes.first)
          end
          formula
        end
      end

      def base_parser
        return unless @nodes.first&.key?("_")

        formula = Plurimath::Math::Formula.new
        @nodes.delete_at(0)
        if Constants::PARENTHESES.key?(@nodes&.first&.first&.first)
          parse_until_closing_parenthesis(formula)
        else
          child_node = intermediate_parse(@nodes.first)
          formula.value << child_node
        end
        formula
      end

      def mod_function_parse(dividend, current_node = @nodes.first)
        @nodes.delete_at(0)
        formula = Plurimath::Math::Formula.new
        if Constants::PARENTHESES.key?(@nodes&.first&.first&.first)
          parse_until_closing_parenthesis(formula)
        else
          child_node = intermediate_parse(@nodes.first)
          formula.value << child_node
        end
        current_node&.first&.last.new(dividend, formula)
      end

      def parse_until_closing_parenthesis(formula, next_node = @nodes.first)
        until @nodes.first.nil?
          formula.value << intermediate_parse(next_node)
          break if Constants::PARENTHESES.value?(next_node&.first&.first)

          if Constants::PARENTHESES.key?(@nodes&.first&.first&.first)
            parse_until_closing_parenthesis(formula)
          end
          next_node = @nodes.first
        end
      end

      def function?(current_node)
        current_node&.first&.last.to_s.include?("Function") unless current_node.nil?
      end

      def number?(current_node = @nodes.first)
        current_node&.first&.last.to_s.include?("Number") unless current_node.nil?
      end

      def text?(current_node)
        current_node&.first&.last.to_s.include?("Text") unless current_node.nil?
      end

      def token
        case @text.peek(1)
        when '"'
          read_quoted_text
        when "t"
          read_text
        when "-", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
          read_number || read_symbols
        else
          read_symbols
        end
      end

      def read_text
        case @text.peek(5)
        when "text("
          read_tex_text
        else
          read_symbols
        end
      end

      def read_tex_text
        read_value(Constants::TEX_TEXT) do |text|
          { text[5..-2] => Plurimath::Math::Function::Text }
        end
      end

      def read_quoted_text
        read_value(Constants::QUOTED_TEXT) do |text|
          { text[1..-2] => Plurimath::Math::Function::Text }
        end
      end

      def read_symbols
        position = @text.pos
        read_value(@symbol_regexp) do |str|
          symbol_or_string(str)
          @text.pos = position + str.length
          type = Constants::SYMBOLS_AND_CLASSES[str.to_sym]
          value = type == :class ? initial_object(str) : Plurimath::Math::Symbol
          { str => value }
        end
      end

      def symbol_or_string(str)
        until str.length == 1 || @symbols.include?(str.to_sym)
          str.chop!
        end
        str
      end

      def read_number
        read_value(Constants::NUMBER) do |number|
          { number => Plurimath::Math::Number }
        end
      end

      def read_value(regex)
        str = @text.scan(regex)
        if str && block_given?
          yield str
        else
          str
        end
      end

      def create_nodes
        @nodes = []
        until @text.eos?
          @text.scan(Constants::WHITESPACES)
          @nodes << token
        end
      end

      def initial_object(formula)
        Object.const_get("Plurimath::Math::Function::#{formula.capitalize}")
      end
    end
  end
end
