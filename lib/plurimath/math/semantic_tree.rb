# frozen_string_literal: true

module Plurimath
  module Math
    # Builds a transient display view using the evaluator's precedence parser.
    # It never evaluates operands or replaces the Formula's stored model.
    class SemanticTree
      View = Struct.new(:label, :children, :source)
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
        @label_context = formula.cloned_objects
        root = evaluate_node(formula)
        (["|_ Semantic tree", "   |_ expression #{label(root.source)}"] + lines(root, 2)).join("\n")
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
          elsif unbound_application?(node)
            offset = application_marker?(tokens[index + 1]) ? 2 : 1
            argument = tokens[index + offset]
            valid_argument!(argument)
            node = bind_application(node, argument)
            index += offset
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
        view("relation #{label(operator)}", left, right,
             source: sequence(left, operator, right))
      end

      def add(left, right)
        view("add #{label(Symbols::Plus.new)}", left, right,
             source: sequence(left, Symbols::Plus.new, right))
      end

      def subtract(left, right)
        view("subtract #{label(Symbols::Minus.new)}", left, right,
             source: sequence(left, Symbols::Minus.new, right))
      end

      def multiply(left, right, implicit:)
        view(implicit ? "implicit multiply" : "multiply", left, right,
             source: sequence(left, implicit ? nil : Symbols::Times.new, right))
      end

      def divide(left, right)
        view("divide", left, right,
             source: sequence(left, Symbols::Symbol.new("/"), right))
      end

      def power(left, right)
        composite("power", Function::Power.new(left.source, right.source),
                  role("base", left), role("script", right))
      end

      def positive(value)
        view("positive", value, source: Formula.new([Symbols::Plus.new, value.source]))
      end

      def negate(value)
        view("negative", value, source: Formula.new([Symbols::Minus.new, value.source]))
      end

      def negated_mod(node)
        left = negate(evaluate_node(node.parameter_one))
        right = evaluate_node(node.parameter_two)
        composite("mod", Function::Mod.new(left.source, right.source), left, right)
      end

      def group(value)
        source = Function::Fenced.new(Symbols::Paren::Lround.new, [value.source], Symbols::Paren::Rround.new)
        composite("group", source, value)
      end

      def nary_function?(node)
        node.is_a?(Function::Int) || node.is_a?(Function::Sum) || node.is_a?(Function::Prod)
      end

      def log_argument(node, argument)
        argument = evaluate_node(argument)
        children = []
        children << view("function name #{label(Function::Log.new)}")
        children << role("base", evaluate_node(node.parameter_one)) if node.parameter_one
        children << role("argument", argument)
        function = node.dup
        function.parameter_two = nil
        result = composite("apply", Formula.new([function, argument.source]), *children)
        node.parameter_two ? power(result, evaluate_node(node.parameter_two)) : result
      end

      def evaluate_node(node)
        case node
        when Formula
          Evaluation::ExpressionParser.new(self, node.value).parse
        when Array
          Evaluation::ExpressionParser.new(self, node).parse
        when Number
          view("number #{label(node)}", source: node)
        when Symbols::Symbol
          symbol(node)
        when Function::Fenced
          fenced(node)
        when Function::Frac
          numerator = evaluate_node(node.parameter_one)
          denominator = evaluate_node(node.parameter_two)
          composite("fraction", with_parameters(node, numerator, denominator),
                    role("numerator", numerator), role("denominator", denominator))
        when Function::Sqrt
          radicand = evaluate_node(node.parameter_one)
          composite("square root", with_parameters(node, radicand),
                    view('degree "⬚"'), role("radicand", radicand))
        when Function::Root
          index = evaluate_node(node.parameter_one)
          radicand = evaluate_node(node.parameter_two)
          composite("root", with_parameters(node, index, radicand),
                    role("index", index), role("radicand", radicand))
        when Function::Power
          power(evaluate_node(node.parameter_one), evaluate_node(node.parameter_two))
        when Function::Base
          base = evaluate_node(node.parameter_one)
          script = evaluate_node(node.parameter_two)
          composite("subscript", with_parameters(node, base, script),
                    role("base", base), role("script", script))
        when Function::PowerBase
          base = evaluate_node(node.parameter_one)
          subscript = evaluate_node(node.parameter_two)
          superscript = evaluate_node(node.parameter_three)
          composite("subsup", with_parameters(node, base, subscript, superscript),
                    role("base", base), role("subscript", subscript), role("superscript", superscript))
        when Function::Int, Function::Sum, Function::Prod
          nary(node)
        when Function::Mod
          left = evaluate_node(node.parameter_one)
          right = evaluate_node(node.parameter_two)
          composite("mod", with_parameters(node, left, right), left, right)
        when Function::FontStyle
          styled_symbol(node)
        when Function::UnaryFunction
          unsupported(node) unless application_function?(node)
          argument = evaluate_node(node.parameter_one)
          composite("apply", with_parameters(node, argument),
                    view("function name #{label(node.class.new, function_name: true)}"),
                    role("argument", argument))
        else
          unsupported(node || "missing operand")
        end
      end

      def unsupported(construct)
        name = construct.is_a?(String) ? construct : construct.class.name.sub(/^Plurimath::Math::/, "")
        raise Errors::UnsupportedSemanticTreeError, name
      end

      private

      def view(label, *children, source: nil)
        View.new(label, children, source)
      end

      def composite(name, source, *children)
        view("#{name} #{label(source)}", *children, source: source)
      end

      def role(name, child)
        composite(name, child.source, child)
      end

      def sequence(left, operator, right)
        Formula.new([left.source, operator, right.source].compact)
      end

      def with_parameters(node, *children)
        copy = node.dup
        children.each_with_index do |child, index|
          copy.public_send("#{Core::ALL_PARAMETERS.fetch(index)}=", child.source)
        end
        copy
      end

      def lines(node, depth)
        ["#{'   ' * depth}|_ #{node.label}"] +
          node.children.flat_map { |child| lines(child, depth + 1) }
      end

      # Use the existing language writers for labels. A copy isolates writer
      # caches from the stored leaf; composite labels are never reparsed.
      def label(node, function_name: false)
        copy = node.cloned_objects
        options = @options.dup
        options[:formula] = @label_context
        text = case @language
               when :mathml
                 copy.dump_mathml(copy, false, options: options)
               when :omml
                 copy.dump_omml(copy, true, options: options)
               else
                 copy.public_send("to_#{@language}", options: options)
               end
        text = text.to_s
        text = text.delete("⁡") if function_name
        text.inspect
      end

      def symbol(node)
        if node.operator? || node.open? || node.close? || relation_operator?(node) || application_marker?(node)
          unsupported(node)
        end
        # Punctuation, separators and unclassified operators cannot safely be
        # treated as operands. Named mathematical letters remain symbol leaves.
        glyph = Utility.html_entity_to_unicode(node.to_unicodemath(options: @options.dup).to_s)
        unsupported(node) unless glyph.match?(/\A[\p{L}\p{N}]+\z/) || %w[∞ ∅].include?(glyph)

        view("symbol #{label(node)}", source: node)
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
          view("symbol #{label(copy)}", source: copy)
        elsif child.is_a?(Symbols::Symbol) || child.is_a?(Number)
          symbol(child) if child.is_a?(Symbols::Symbol)
          copy = node.dup
          copy.parameter_one = child.dup
          view("symbol #{label(copy)}", source: copy)
        else
          unsupported("#{node.class.name.sub(/^Plurimath::Math::/, '')} (non-atomic font style)")
        end
      end

      def nary(node)
        children = []
        lower = evaluate_node(node.parameter_one) if node.parameter_one
        upper = evaluate_node(node.parameter_two) if node.parameter_two
        body = evaluate_node(node.parameter_three)
        children << role("lower limit", lower) if lower
        children << role("upper limit", upper) if upper
        children << role(node.is_a?(Function::Int) ? "integrand" : "body", body)
        source = node.dup
        source.parameter_one = lower&.source
        source.parameter_two = upper&.source
        source.parameter_three = body.source
        composite(node.class::FUNCTION.fetch(:name), source, *children)
      end

      def application_function?(node)
        node.is_a?(Function::UnaryFunction) && APPLICATIONS.include?(node.class.name.split("::").last)
      end

      # A function power such as sin^2 carries the exponent on an unbound
      # function node. Bind its following operand inside the power, so the
      # result is (sin x)^2, while retaining the shared parser's precedence.
      def unbound_application?(node)
        return unbound_application?(node.parameter_one) if node.is_a?(Function::Power)

        application_function?(node) &&
          (node.parameter_one.nil? || application_marker?(node.parameter_one))
      end

      def bind_application(node, argument)
        copy = node.dup
        copy.parameter_one = if node.is_a?(Function::Power)
                               bind_application(node.parameter_one, argument)
                             else
                               argument
                             end
        copy
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
