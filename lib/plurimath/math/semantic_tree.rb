# frozen_string_literal: true

module Plurimath
  module Math
    # Builds a transient display view using the evaluator's precedence parser.
    # It never evaluates operands or replaces the Formula's stored model.
    class SemanticTree
      View = Struct.new(:label, :children)
      private_constant :View

      LANGUAGES = %i[omml latex mathml asciimath unicodemath].freeze
      private_constant :LANGUAGES

      RELATIONS = %w[Equal Less Greater Lt Gt Le Ge Leq Geq Ne Neq].freeze
      APPLICATIONS = %w[
        Sin Cos Tan Cot Sec Csc Sinh Cosh Tanh Coth Sech Csch
        Arcsin Arccos Arctan Arccot Arcsec Arccsc Arcsinh Arccosh Arctanh
        Ln Exp Abs Sgn Det Min Max Gcd Lcm
      ].freeze
      private_constant :RELATIONS, :APPLICATIONS

      def initialize(language, options)
        unsupported("label language #{language.inspect}") unless LANGUAGES.include?(language)
        @language = language
        @options = options
      end

      def render(formula)
        root = evaluate_node(formula)
        (["|_ Semantic tree"] + lines(root, 1)).join("\n")
      end

      # Normalize only the symbolic backend's input. Some source parsers store
      # Unicode minus and function application as generic Symbol instances.
      def normalize_tokens(tokens)
        normalized = []
        index = 0
        while index < tokens.length
          node = tokens[index]
          if node.instance_of?(Symbols::Symbol) && ["−", "&#x2212;"].include?(node.value)
            node = Symbols::Minus.new
          elsif application_function?(node) && application_marker?(node.parameter_one)
            argument = tokens[index + 1]
            valid_argument!(argument)
            node = node.class.new(argument)
            index += 1
          elsif application_function?(node) && node.parameter_one.nil? &&
              application_marker?(tokens[index + 1])
            argument = tokens[index + 2]
            valid_argument!(argument)
            node = node.class.new(argument)
            index += 2
          end
          normalized << node
          index += 1
        end
        normalized
      end

      def relation_operator?(node)
        return false unless node.is_a?(Symbols::Symbol)

        RELATIONS.include?(node.class.name.split("::").last) ||
          (node.instance_of?(Symbols::Symbol) && %w[= < > <= >= != ≤ ≥ ≠].include?(node.value))
      end

      def relation(operator, left, right)
        view("relation #{label(operator)}", left, right)
      end

      def add(left, right)
        view("add #{label(Symbols::Plus.new)}", left, right)
      end

      def subtract(left, right)
        view("subtract #{label(Symbols::Minus.new)}", left, right)
      end

      def multiply(left, right, implicit:)
        view(implicit ? "implicit multiply" : "multiply", left, right)
      end

      def divide(left, right)
        view("divide", left, right)
      end

      def power(left, right)
        view("power", left, right)
      end

      def positive(value)
        view("positive", value)
      end

      def negate(value)
        view("negative", value)
      end

      def negated_mod(node)
        view("mod", negate(evaluate_node(node.parameter_one)), evaluate_node(node.parameter_two))
      end

      def group(value)
        view("group", value)
      end

      def nary_function?(node)
        node.is_a?(Function::Int) || node.is_a?(Function::Sum) || node.is_a?(Function::Prod)
      end

      def log_argument(node, argument)
        children = []
        children << view("base", evaluate_node(node.parameter_one)) if node.parameter_one
        children << view("argument", evaluate_node(argument))
        result = view("apply #{label(Function::Log.new)}", *children)
        node.parameter_two ? power(result, evaluate_node(node.parameter_two)) : result
      end

      def evaluate_node(node)
        case node
        when Formula
          Evaluation::ExpressionParser.new(self, node.value).parse
        when Array
          Evaluation::ExpressionParser.new(self, node).parse
        when Number
          view("number #{label(node)}")
        when Symbols::Symbol
          symbol(node)
        when Function::Fenced
          fenced(node)
        when Function::Frac
          view("fraction", evaluate_node(node.parameter_one), evaluate_node(node.parameter_two))
        when Function::Sqrt
          view("square root", evaluate_node(node.parameter_one))
        when Function::Root
          view("root", view("index", evaluate_node(node.parameter_one)),
               view("radicand", evaluate_node(node.parameter_two)))
        when Function::Power
          power(evaluate_node(node.parameter_one), evaluate_node(node.parameter_two))
        when Function::Base
          view("subscript", evaluate_node(node.parameter_one), evaluate_node(node.parameter_two))
        when Function::PowerBase
          view("subsup", view("base", evaluate_node(node.parameter_one)),
               view("subscript", evaluate_node(node.parameter_two)),
               view("superscript", evaluate_node(node.parameter_three)))
        when Function::Int, Function::Sum, Function::Prod
          nary(node)
        when Function::Mod
          view("mod", evaluate_node(node.parameter_one), evaluate_node(node.parameter_two))
        when Function::FontStyle
          styled_symbol(node)
        when Function::UnaryFunction
          unsupported(node) unless application_function?(node)
          view("apply #{label(node.class.new)}", evaluate_node(node.parameter_one))
        else
          unsupported(node || "missing operand")
        end
      end

      def unsupported(construct)
        name = construct.is_a?(String) ? construct : construct.class.name.sub(/^Plurimath::Math::/, "")
        raise Errors::UnsupportedSemanticTreeError, name
      end

      private

      def view(label, *children)
        View.new(label, children)
      end

      def lines(node, depth)
        ["#{'   ' * depth}|_ #{node.label}"] +
          node.children.flat_map { |child| lines(child, depth + 1) }
      end

      # Use the existing language writers for labels. A copy isolates writer
      # caches from the stored leaf; composite labels are never reparsed.
      def label(node)
        copy = node.dup
        options = @options.dup
        text = case @language
               when :mathml
                 copy.dump_mathml(copy, false, options: options)
               when :omml
                 copy.dump_omml(copy, true, options: options)
               else
                 copy.public_send("to_#{@language}", options: options)
               end
        text.to_s.inspect
      end

      def symbol(node)
        if node.operator? || node.open? || node.close? || relation_operator?(node) || application_marker?(node)
          unsupported(node)
        end
        # Punctuation, separators and unclassified operators cannot safely be
        # treated as operands. Named mathematical letters remain symbol leaves.
        glyph = Utility.html_entity_to_unicode(node.to_unicodemath(options: @options.dup).to_s)
        unsupported(node) unless glyph.match?(/\A[\p{L}\p{N}]+\z/) || %w[∞ ∅].include?(glyph)

        view("symbol #{label(node)}")
      end

      def fenced(node)
        left = node.parameter_one
        right = node.parameter_three
        unless left.nil? == right.nil? &&
            (left.nil? || left.is_a?(Symbols::Paren::Lround)) &&
            (right.nil? || right.is_a?(Symbols::Paren::Rround))
          unsupported("Function::Fenced (non-round or unmatched delimiters)")
        end
        group(evaluate_node(node.parameter_two))
      end

      def styled_symbol(node)
        child = node.parameter_one
        if child.is_a?(Function::Text) && child.parameter_one.to_s.match?(/\A\p{L}\z/)
          copy = node.dup
          copy.parameter_one = child.dup
          view("symbol #{label(copy)}")
        elsif child.is_a?(Symbols::Symbol) || child.is_a?(Number)
          symbol(child) if child.is_a?(Symbols::Symbol)
          copy = node.dup
          copy.parameter_one = child.dup
          view("symbol #{label(copy)}")
        else
          unsupported("#{node.class.name.sub(/^Plurimath::Math::/, '')} (non-atomic font style)")
        end
      end

      def nary(node)
        children = []
        children << view("lower limit", evaluate_node(node.parameter_one)) if node.parameter_one
        children << view("upper limit", evaluate_node(node.parameter_two)) if node.parameter_two
        children << view(node.is_a?(Function::Int) ? "integrand" : "body", evaluate_node(node.parameter_three))
        view(node.class::FUNCTION.fetch(:name), *children)
      end

      def application_function?(node)
        node.is_a?(Function::UnaryFunction) && APPLICATIONS.include?(node.class.name.split("::").last)
      end

      def application_marker?(node)
        node.is_a?(Symbols::Funcapply) ||
          (node.instance_of?(Symbols::Symbol) && ["⁡", "&#x2061;"].include?(node.value))
      end

      def valid_argument!(node)
        if !node.is_a?(Core) || node.operator? || node.open? || node.close? || relation_operator?(node)
          unsupported("function application (missing or ambiguous argument)")
        end
      end
    end
  end
end
