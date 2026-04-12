# frozen_string_literal: true

require "mml"

module Plurimath
  class Mathml
    class Translator
      include Mathml::Utility::FormulaTransformation

      def initialize
        @memoized = {}
      end

      # Main entry point: Mml model → Plurimath model
      def mml_to_plurimath(mml_node)
        return nil if mml_node.nil?

        case mml_node
        when Mml::V4::Math then math_to_formula(mml_node)
        when Mml::V4::Mrow then mrow_to_mrow(mml_node)
        when Mml::V4::Mover then mover_to_overset(mml_node)
        when Mml::V4::Munder then munder_to_underset(mml_node)
        when Mml::V4::Munderover then munderover_to_underover(mml_node)
        when Mml::V4::Msup then msup_to_power(mml_node)
        when Mml::V4::Msub then msub_to_base(mml_node)
        when Mml::V4::Msubsup then msubsup_to_powerbase(mml_node)
        when Mml::V4::Mfrac then mfrac_to_frac(mml_node)
        when Mml::V4::Msqrt then msqrt_to_sqrt(mml_node)
        when Mml::V4::Mroot then mroot_to_root(mml_node)
        when Mml::V4::Mi then mi_to_symbol(mml_node)
        when Mml::V4::Mo then mo_to_symbol(mml_node)
        when Mml::V4::Mn then mn_to_number(mml_node)
        when Mml::V4::Mtext then mtext_to_text(mml_node)
        when Mml::V4::Mstyle then mstyle_to_mstyle(mml_node)
        when Mml::V4::Mtable then mtable_to_table(mml_node)
        when Mml::V4::Mtr then mtr_to_tr(mml_node)
        when Mml::V4::Mtd then mtd_to_td(mml_node)
        when Mml::V4::Mfenced then mfenced_to_fenced(mml_node)
        when Mml::V4::Mphantom then mphantom_to_phantom(mml_node)
        when Mml::V4::Menclose then menclose_to_menclose(mml_node)
        when Mml::V4::Merror then merror_to_merror(mml_node)
        when Mml::V4::Mlongdiv then mlongdiv_to_longdiv(mml_node)
        when Mml::V4::Mstack then mstack_to_stackrel(mml_node)
        when Mml::V4::Msgroup then msgroup_to_msgroup(mml_node)
        when Mml::V4::Msline then msline_to_msline(mml_node)
        when Mml::V4::Mpadded then mpadded_to_mpadded(mml_node)
        when Mml::V4::Mglyph then mglyph_to_mglyph(mml_node)
        when Mml::V4::Mmultiscripts then mmultiscripts_to_multiscript(mml_node)
        when Mml::V4::Mlabeledtr then mlabeledtr_to_mlabeledtr(mml_node)
        when Mml::V4::Semantics then semantics_to_semantics(mml_node)
        when Mml::V4::None then none_to_none
        when Mml::V4::Ms then ms_to_ms(mml_node)
        when Mml::V4::Mscarries then mscarries_to_scarries(mml_node)
        when Mml::V4::Mscarry then mscarry_to_mscarry(mml_node)
        when Mml::V4::Annotation then nil
        when Mml::V4::AnnotationXml then nil
        when Mml::V4::Mspace then mspace_to_space(mml_node)
        when Mml::V4::Mprescripts then mprescripts_to_prescripts(mml_node)
        else
          raise "Unknown mml node type: #{mml_node.class}"
        end
      end

      private

      # Use each_mixed_content to get children in document order
      # This fixes the mover children swap bug!
      def ordered_children(node)
        children = []
        node.each_mixed_content { |child| children << child }
        children
      end

      # MathML element: <math>
      def math_to_formula(math)
        children = ordered_children(math)
        formula_values = children.map { |child| mml_to_plurimath(child) }.compact
        formula_values = filter_values(formula_values)
        Plurimath::Math::Formula.new(formula_values)
      end

      # MathML element: <mrow>
      def mrow_to_mrow(mrow)
        children = ordered_children(mrow)
        formula_values = children.map { |child| mml_to_plurimath(child) }.compact
        combined = combine_function_with_parens(formula_values)
        return combined.first if combined.size == 1

        mrow_obj = Plurimath::Math::Formula::Mrow.new(combined)
        mrow_obj.send(:organize_value)
        values = mrow_obj.value
        # Apply nary conversion after organize_value
        values = filter_values(values)
        values.size == 1 ? values.first : Plurimath::Math::Formula::Mrow.new(values)
      end

      # MathML element: <mover> base overscript
      # Note: Overset convention is parameter_one=overscript, parameter_two=base
      # (reversed from MathML document order) to match rendering methods
      def mover_to_overset(mover)
        children = ordered_children(mover)
        base = mml_to_plurimath(children[0])
        overscript = mml_to_plurimath(children[1])
        Plurimath::Math::Function::Overset.new(overscript, base)
      end

      # MathML element: <munder> base underscript
      def munder_to_underset(munder)
        children = ordered_children(munder)
        base = mml_to_plurimath(children[0])
        underscript = mml_to_plurimath(children[1])
        Plurimath::Math::Function::Underset.new(underscript, base)
      end

      # MathML element: <munderover> base underscript overscript
      def munderover_to_underover(munderover)
        children = ordered_children(munderover)
        base = mml_to_plurimath(children[0])
        underscript = mml_to_plurimath(children[1])
        overscript = mml_to_plurimath(children[2])
        Plurimath::Math::Function::Underover.new(base, underscript, overscript)
      end

      # MathML element: <msup> base superscript
      def msup_to_power(sup)
        children = ordered_children(sup)
        base = mml_to_plurimath(children[0])
        superscript = mml_to_plurimath(children[1])
        Plurimath::Math::Function::Power.new(base, superscript)
      end

      # MathML element: <msub> base subscript
      def msub_to_base(sub)
        children = ordered_children(sub)
        base = mml_to_plurimath(children[0])
        subscript = mml_to_plurimath(children[1])
        Plurimath::Math::Function::Base.new(base, subscript)
      end

      # MathML element: <msubsup> base subscript superscript
      def msubsup_to_powerbase(subsup)
        children = ordered_children(subsup)
        base = mml_to_plurimath(children[0])
        subscript = mml_to_plurimath(children[1])
        superscript = mml_to_plurimath(children[2])
        Plurimath::Math::Function::PowerBase.new(base, subscript, superscript)
      end

      # MathML element: <mi> - identifier
      def mi_to_symbol(mi)
        value = mi.value || ""
        # Check if it's a known function name first (only for non-whitespace values)
        stripped = value.strip
        function_class = MATHML_FUNCTION_CLASSES[stripped]
        if function_class
          return Plurimath::Math::Function.const_get(function_class).new
        end
        # Use the same symbol resolution as the old parser
        result = Plurimath::Utility.mathml_unary_classes([stripped], lang: :mathml)
        # Apply mathvariant font styling if present
        apply_font_style(mi, result)
      end

      # MathML element: <mo> - operator
      def mo_to_symbol(mo)
        value = (mo.value || "").strip
        # Handle linebreak="newline" attribute - creates a Linebreak wrapper
        if mo.linebreak == "newline"
          return Plurimath::Math::Function::Linebreak.new(
            Plurimath::Math::Symbols::Symbol.new(value)
          )
        end
        # Use the same symbol resolution as the old parser
        result = Plurimath::Utility.mathml_unary_classes([value], lang: :mathml)
        if result.is_a?(Plurimath::Math::Symbols::Symbol)
          result.mo_element = true
        end
        result
      end

      # MathML element: <mn> - number
      def mn_to_number(mn)
        value = mn.value || ""
        Plurimath::Math::Number.new(value)
      end

      # MathML element: <mtext> - text
      def mtext_to_text(mtext)
        value = mtext.value
        # mtext.value can be an Array when there's mixed content (text + elements)
        # Join array into string, filter empty strings, and handle nil
        if value.is_a?(Array)
          value = value.reject(&:empty?).join
        end
        value ||= ""
        Plurimath::Math::Function::Text.new(value)
      end

      # MathML element: <none>
      def none_to_none
        Plurimath::Math::Function::None.new
      end

      # MathML element: <ms> - string
      def ms_to_ms(ms)
        children = ordered_children(ms)
        text_content = children.map do |child|
          pl = mml_to_plurimath(child)
          pl.to_ms_value
        end.join(" ")
        Plurimath::Math::Function::Ms.new(text_content)
      end

      # MathML element: <mfrac> numerator denominator
      def mfrac_to_frac(frac)
        children = ordered_children(frac)
        numerator = mml_to_plurimath(children[0])
        denominator = mml_to_plurimath(children[1])
        Plurimath::Math::Function::Frac.new(numerator, denominator)
      end

      # MathML element: <msqrt> - square root
      def msqrt_to_sqrt(sqrt)
        children = ordered_children(sqrt)
        radicand = children.map { |child| mml_to_plurimath(child) }.compact
        radicand = radicand.first if radicand.size == 1
        Plurimath::Math::Function::Sqrt.new(radicand)
      end

      # MathML element: <mroot> radicand index
      def mroot_to_root(root)
        children = ordered_children(root)
        radicand = mml_to_plurimath(children[0])
        index = mml_to_plurimath(children[1])
        Plurimath::Math::Function::Root.new(radicand, index)
      end

      # MathML element: <mphantom> - phantom
      def mphantom_to_phantom(phantom)
        children = ordered_children(phantom)
        content = children.map { |child| mml_to_plurimath(child) }.compact
        Plurimath::Math::Function::Phantom.new(content)
      end

      # MathML element: <menclose> - enclose
      def menclose_to_menclose(enclose)
        children = ordered_children(enclose)
        content = children.map { |child| mml_to_plurimath(child) }.compact
        notation = enclose.notation
        content_obj = content.size == 1 ? content.first : Plurimath::Math::Formula.new(content)
        Plurimath::Math::Function::Menclose.new(notation, content_obj)
      end

      # MathML element: <merror> - error
      def merror_to_merror(error)
        children = ordered_children(error)
        content = children.map { |child| mml_to_plurimath(child) }.compact
        Plurimath::Math::Function::Merror.new(content)
      end

      # MathML element: <mstyle> - style
      def mstyle_to_mstyle(style)
        children = ordered_children(style)
        content = children.map { |child| mml_to_plurimath(child) }.compact

        # If mstyle has mathvariant, wrap content in font style
        if style.respond_to?(:mathvariant) && style.mathvariant
          style_name = MATHVARIANT_FONT_STYLES[style.mathvariant]
          if style_name
            style_class = Plurimath::Math::Function::FontStyle.const_get(style_name)
            inner = content.size == 1 ? content.first : Plurimath::Math::Formula.new(content)
            return style_class.new(inner)
          end
        end

        # Apply nary conversion to children
        content = filter_values(content)

        mstyle = Plurimath::Math::Formula::Mstyle.new(content)
        mstyle.left_right_wrapper = false
        if style.respond_to?(:displaystyle) && !style.displaystyle.nil? && style.displaystyle.to_s != ""
          mstyle.displaystyle = style.displaystyle
        end
        mstyle
      end

      # MathML element: <mfenced> - fenced
      def mfenced_to_fenced(fenced)
        children = ordered_children(fenced)
        content = children.map { |child| mml_to_plurimath(child) }.compact
        open = fenced.open&.value || "("
        close = fenced.close&.value || ")"
        Plurimath::Math::Function::Fenced.new(content, open: open, close: close)
      end

      # MathML element: <mtable> - table
      def mtable_to_table(table)
        rows = table.mtr_value || []
        table_content = rows.map do |row|
          cells = ordered_children(row).map { |cell| mml_to_plurimath(cell) }
          Plurimath::Math::Function::Tr.new(cells)
        end
        table_obj = Plurimath::Math::Function::Table.new(table_content)
        # Set table attributes
        table_obj.frame = table.frame if table.respond_to?(:frame) && table.frame
        table_obj.rowlines = table.rowlines if table.respond_to?(:rowlines) && table.rowlines
        table_obj.columnlines = table.columnlines if table.respond_to?(:columnlines) && table.columnlines
        table_obj
      end

      # MathML element: <mtr> - table row
      def mtr_to_tr(tr)
        cells = ordered_children(tr).map { |cell| mml_to_plurimath(cell) }
        Plurimath::Math::Function::Tr.new(cells)
      end

      # MathML element: <mtd> - table cell
      def mtd_to_td(td)
        children = ordered_children(td)
        content = children.map { |child| mml_to_plurimath(child) }.compact
        Plurimath::Math::Function::Td.new(content)
      end

      # MathML element: <mlongdiv> - long division
      def mlongdiv_to_longdiv(longdiv)
        children = ordered_children(longdiv)
        content = children.map { |child| mml_to_plurimath(child) }.compact
        Plurimath::Math::Function::Longdiv.new(content)
      end

      # MathML element: <mstack> - stacked
      def mstack_to_stackrel(stack)
        children = ordered_children(stack)
        content = children.map { |child| mml_to_plurimath(child) }.compact
        Plurimath::Math::Function::Stackrel.new(content)
      end

      # MathML element: <msgroup> - group
      def msgroup_to_msgroup(sgroup)
        children = ordered_children(sgroup)
        content = children.map { |child| mml_to_plurimath(child) }.compact
        Plurimath::Math::Function::Msgroup.new(content)
      end

      # MathML element: <msline> - line
      def msline_to_msline(sline)
        children = ordered_children(sline)
        content = children.map { |child| mml_to_plurimath(child) }.compact
        Plurimath::Math::Function::Msline.new(content)
      end

      # MathML element: <mpadded> - padded
      def mpadded_to_mpadded(padded)
        children = ordered_children(padded)
        content = children.map { |child| mml_to_plurimath(child) }.compact
        Plurimath::Math::Function::Mpadded.new(content)
      end

      # MathML element: <mglyph> - glyph
      def mglyph_to_mglyph(glyph)
        src = glyph.src
        alt = glyph.alt
        index = glyph.index
        Plurimath::Math::Function::Mglyph.new(src: src, alt: alt, index: index)
      end

      # MathML element: <mmultiscripts> - multiscripts
      def mmultiscripts_to_multiscript(multiscripts)
        children = ordered_children(multiscripts)
        return Plurimath::Math::Function::Multiscript.new if children.empty?

        # Find mprescripts boundary using element_order
        has_prescripts = !multiscripts.mprescripts_value.nil?
        element_order = multiscripts.element_order
        mpre_index = element_order.index { |el| el.name == "mprescripts" }

        if has_prescripts && mpre_index
          # Get element names before and after mprescripts
          post_names = element_order[0...mpre_index].select { |el| el.node_type == :element }.map(&:name)
          pre_names = element_order[(mpre_index + 1)..-1].select { |el| el.node_type == :element }.map(&:name)

          # Count post-script elements (excluding base which is first)
          post_element_count = post_names.size - 1  # subtract base

          # Split ordered children
          base = children[0]
          post_children = children[1..post_element_count]
          pre_children = children[(post_element_count + 1)..-1]

          base_plurimath = mml_to_plurimath(base)

          # Build post-script pairs
          post_pairs = post_children.each_slice(2).to_a
          post_subs = post_pairs.map { |pair| mml_to_plurimath(pair[0]) }
          post_sups = post_pairs.map { |pair| mml_to_plurimath(pair[1]) if pair[1] }

          # Build pre-script pairs
          pre_pairs = pre_children.each_slice(2).to_a
          pre_subs = pre_pairs.map { |pair| mml_to_plurimath(pair[0]) }
          pre_sups = pre_pairs.map { |pair| mml_to_plurimath(pair[1]) if pair[1] }

          # Create base element with post-scripts
          if post_subs.any? || post_sups.any?
            sub_value = post_subs.first
            sup_value = post_sups.first
            base_with_posts = Plurimath::Math::Function::PowerBase.new(base_plurimath, sub_value, sup_value)
          else
            base_with_posts = base_plurimath
          end

          Plurimath::Math::Function::Multiscript.new(base_with_posts, pre_subs, pre_sups)
        else
          # No prescripts - children are base followed by (sub, sup) pairs
          base = children[0]
          base_plurimath = mml_to_plurimath(base)
          remaining = children[1..-1]
          pairs = remaining.each_slice(2).to_a
          subscripts = pairs.map { |pair| mml_to_plurimath(pair[0]) if pair[0] }.compact
          superscripts = pairs.map { |pair| mml_to_plurimath(pair[1]) if pair[1] }.compact
          Plurimath::Math::Function::Multiscript.new(base_plurimath, subscripts, superscripts)
        end
      end

      # MathML element: <mlabeledtr> - labeled row
      def mlabeledtr_to_mlabeledtr(labeledtr)
        children = ordered_children(labeledtr)
        content = children.map { |child| mml_to_plurimath(child) }.compact
        Plurimath::Math::Function::Mlabeledtr.new(content)
      end

      # MathML element: <semantics> - semantics
      def semantics_to_semantics(semantics)
        children = ordered_children(semantics)
        # First child is the annotated math element
        math_content = children[0] ? mml_to_plurimath(children[0]) : nil
        Plurimath::Math::Function::Semantics.new(math_content)
      end

      # MathML element: <mscarries> - carries
      def mscarries_to_scarries(scarries)
        children = ordered_children(scarries)
        content = children.map { |child| mml_to_plurimath(child) }.compact
        Plurimath::Math::Function::Scarries.new(content)
      end

      # MathML element: <mscarry> - carry
      def mscarry_to_mscarry(scarry)
        children = ordered_children(scarry)
        content = children.map { |child| mml_to_plurimath(child) }.compact
        Plurimath::Math::Function::Scarry.new(content)
      end

      # MathML element: <mprescripts> - prescripts marker
      # This is a marker element, returns nil (filtered out)
      def mprescripts_to_prescripts(_)
        nil
      end

      # MathML element: <mspace> - space
      def mspace_to_space(space)
        # Mspace represents horizontal whitespace
        # Use width attribute if present, otherwise default space
        width = space.width&.value if space.respond_to?(:width)
        Plurimath::Math::Symbols::Space.new
      end

      def mathml_symbol_classes
        @mathml_symbol_classes ||= self.class.build_mathml_symbol_lookup.freeze
      end

      # Build a lookup hash mapping mathml values to Symbol class names
      def self.build_mathml_symbol_lookup
        lookup = {}
        excluded = %w[Lparen Rparen]
        Plurimath::Math::Symbols.constants.grep(/^[A-Z][a-z]+$/).each do |const_name|
          next if excluded.include?(const_name.to_s)
          klass = Plurimath::Math::Symbols.const_get(const_name)
          next unless klass.respond_to?(:input) && klass < Plurimath::Math::Symbols::Symbol
          mathml_inputs = klass.input(:mathml)
          next unless mathml_inputs
          Array(mathml_inputs).each do |mathml_value|
            # Normalize entity form &#x3b1; to unicode α
            normalized = normalize_mathml_value(mathml_value)
            lookup[normalized] = const_name
          end
        end
        lookup
      end

      def self.normalize_mathml_value(value)
        if value.start_with?("&#x") && value.end_with?(";")
          [value[3..-2].to_i(16)].pack("U")
        else
          value
        end
      end

      # Build a lookup hash mapping MathML identifier values to Function class names
      MATHML_FUNCTION_CLASSES = {
        # Trigonometric functions
        "sin"   => "Sin",
        "cos"   => "Cos",
        "tan"   => "Tan",
        "cot"   => "Cot",
        "sec"   => "Sec",
        "csc"   => "Csc",
        # Hyperbolic functions
        "sinh"  => "Sinh",
        "cosh"  => "Cosh",
        "tanh"  => "Tanh",
        "coth"  => "Coth",
        "sech"  => "Sech",
        "csch"  => "Csch",
        # Inverse trigonometric functions
        "arcsin"  => "Arcsin",
        "arccos"  => "Arccos",
        "arctan"  => "Arctan",
        "arccot"  => "Arccot",
        "arcsec"  => "Arcsec",
        "arccsc"  => "Arccsc",
        # Inverse hyperbolic functions
        "arsinh"  => "Arsinh",
        "arcosh"  => "Arcosh",
        "artanh"  => "Artanh",
        "arcoth"  => "Arcoth",
        "arsech"  => "Arsech",
        "arcsch"  => "Arcsch",
        # Exponential and logarithmic
        "exp"   => "Exp",
        "log"   => "Log",
        "ln"    => "Ln",
        "lg"    => "Lg",
        # Limits and extrema
        "lim"   => "Lim",
        "liminf" => "Liminf",
        "limsup" => "Limsup",
        "inf"   => "Inf",
        "sup"   => "Sup",
        "max"   => "Max",
        "min"   => "Min",
        # Other mathematical functions
        "det"   => "Det",
        "gcd"   => "Gcd",
        "dim"   => "Dim",
        "hom"   => "Hom",
        "ker"   => "Ker",
        "deg"   => "Deg",
        "mod"   => "Mod",
        "arg"   => "Arg",
        # Operators as functions
        "abs"   => "Abs",
        "norm"  => "Norm",
        "floor" => "Floor",
        "ceil"  => "Ceil",
        "sgn"   => "Sgn",
        # Sum and product
        "sum"   => "Sum",
        "prod"  => "Prod",
        # Integral
        "int"   => "Int",
        "oint"  => "Oint",
      }.freeze

      # Heuristic: combine function name with following opening parenthesis
      # This replicates old parser behavior for cases like <mi>cos</mi><mo>(</mo>
      # When we see Function class followed by an opening parenthesis, combine them
      def combine_function_with_parens(values)
        return values if values.size < 2

        result = []
        i = 0
        while i < values.size
          current = values[i]
          if i + 1 < values.size && can_combine_with_paren?(current)
            next_elem = values[i + 1]
            if opening_paren?(next_elem)
              # Create a plain Symbol("(") as the function parameter
              paren = Plurimath::Math::Symbols::Symbol.new("(", mo_element: true)
              combined = current.class.new(paren)
              result << combined
              i += 2  # Skip both
              next
            end
          end
          result << current
          i += 1
        end
        result
      end

      # Check if the element is an opening parenthesis (plain Symbol or Paren class)
      def opening_paren?(obj)
        return true if obj.is_a?(Plurimath::Math::Symbols::Symbol) && obj.value == "("
        return true if obj.class_name == "lround"
        return true if obj.respond_to?(:paren?) && obj.paren? && obj.respond_to?(:to_asciimath) && obj.to_asciimath(options: {}) == "("

        false
      end

      # Functions that can be combined with opening paren heuristic
      def can_combine_with_paren?(obj)
        return false unless obj.respond_to?(:class)

        klass = obj.class
        # Check if it's a UnaryFunction subclass (these are typically written as func(x))
        klass < Plurimath::Math::Function::UnaryFunction
      end

      # Map mathvariant values to font style classes
      MATHVARIANT_FONT_STYLES = {
        "normal" => "Normal",
        "italic" => "Italic",
        "bold" => "Bold",
        "bold-italic" => "BoldItalic",
        "fraktur" => "Fraktur",
        "bold-fraktur" => "BoldFraktur",
        "script" => "Script",
        "bold-script" => "BoldScript",
        "monospace" => "Monospace",
        "double-struck" => "DoubleStruck",
        "sans-serif" => "SansSerif",
        "bold-sans-serif" => "BoldSansSerif",
        "sans-serif-italic" => "SansSerifItalic",
        "sans-serif-bold-italic" => "SansSerifBoldItalic",
      }.freeze

      # Apply font styling based on mathvariant attribute
      def apply_font_style(element, result)
        return result unless element.respond_to?(:mathvariant) && element.mathvariant

        style_name = MATHVARIANT_FONT_STYLES[element.mathvariant]
        return result unless style_name

        style_class = Plurimath::Math::Function::FontStyle.const_get(style_name)
        style_class.new(result)
      end
    end
  end
end