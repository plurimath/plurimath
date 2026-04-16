# frozen_string_literal: true

require "mml"

module Plurimath
  class Mathml
    class Translator
      include Mathml::FormulaTransformation

      def initialize
        @memoized = {}
      end

      # Main entry point: Mml model → Plurimath model
      def mml_to_plurimath(mml_node)
        return nil if mml_node.nil?

        case mml_node
        when String then text_node_to_plurimath(mml_node)
        when Mml::V4::Math then math_to_formula(mml_node)
        when Mml::V4::Mrow then mrow_to_mrow(mml_node)
        when Mml::V4::Mover then mover_to_overset(mml_node)
        when Mml::V4::Munder then munder_to_underset(mml_node)
        when Mml::V4::Munderover then munderover_to_underover(mml_node)
        when Mml::V4::Msup then msup_to_power(mml_node)
        when Mml::V4::Msub then msub_to_base(mml_node)
        when Mml::V4::Msubsup then msubsup_to_powerbase(mml_node)
        when Mml::V4::Mfrac then mfrac_to_frac(mml_node)
        when Mml::V4::Mfraction then mfrac_to_frac(mml_node)
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
        when Mml::V4::Msrow then msrow_to_formula(mml_node)
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
        when Mml::V4::Malignmark then nil
        when Mml::V4::Maligngroup then nil
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

      def text_value(value)
        return if value.nil?
        return value if value.is_a?(String)

        Array(value).join
      end

      def mathml_symbol(value)
        Plurimath::Utility.mathml_unary_classes([value], lang: :mathml)
      end

      # Alignment markers affect MathML layout only; the old parser dropped them
      # before building the Plurimath AST.
      def content_children(node)
        ordered_children(node).reject do |child|
          child.is_a?(Mml::V4::Malignmark) || child.is_a?(Mml::V4::Maligngroup)
        end
      end

      # MathML element: <math>
      def math_to_formula(math)
        children = ordered_children(math)
        formula_values = children.map { |child| mml_to_plurimath(child) }.compact
        formula_values = nary_check(formula_values)
        display_style = boolean_to_displaystyle(math.display)

        if formula_values.length == 1 && formula_values.first.respond_to?(:is_mstyle?) && formula_values.first.is_mstyle?
          mstyle = formula_values.first
          formula_values = Array(mstyle.value)
          display_style = mstyle.displaystyle
        end

        Plurimath::Math::Formula.new(
          formula_values,
          display_style: display_style,
        )
      end

      # MathML element: <mrow>
      def mrow_to_mrow(mrow)
        children = ordered_children(mrow)
        formula_values = children.map { |child| mml_to_plurimath(child) }.compact
        return nil if formula_values.empty?

        combined = nary_check(combine_function_with_parens(formula_values))
        mrow_obj = Plurimath::Math::Formula::Mrow.new(combined)
        mrow_obj.send(:organize_value)
        preserve_explicit_nary_body!(mrow_obj.value)
        fill_ternary_third_values(mrow_obj.value)
        return mrow_obj.value.first if mrow_obj.value.length == 1

        if mrow.respond_to?(:intent) && mrow.intent && !mrow.intent.empty?
          content = mrow_obj.is_a?(Plurimath::Math::Formula) ? mrow_obj : Plurimath::Math::Formula.new([mrow_obj])
          return Plurimath::Math::Function::Intent.new(
            content,
            Plurimath::Math::Function::Text.new(mrow.intent),
          )
        end

        Plurimath::Math::Formula.new(mrow_obj.value)
      end

      # MathML element: <mover> base overscript
      # Note: Overset convention is parameter_one=overscript, parameter_two=base
      # (reversed from MathML document order) to match rendering methods
      def mover_to_overset(mover)
        children = content_children(mover)
        base = filter_child(mml_to_plurimath(children[0]))
        overscript = filter_child(mml_to_plurimath(children[1]))
        options = {}
        options[:accent] = true if truthy_mathml_bool?(mover.accent)

        case overscript&.class_name
        when "obrace", "ubrace"
          overscript.parameter_one = base
          overscript
        when "hat", "ddot", "vec", "tilde"
          overscript.parameter_one = base
          overscript.attributes = options if overscript.respond_to?(:attributes=)
          overscript
        when "period", "dot"
          new_element = overscript.is_a?(Plurimath::Math::Symbols::Period) ? Plurimath::Math::Function::Dot.new : overscript
          new_element.parameter_one = base
          new_element.attributes = options if new_element.respond_to?(:attributes=)
          new_element
        when "bar"
          overscript.parameter_one = base
          overscript
        when "ul", "underline"
          Plurimath::Math::Function::Bar.new(base, options)
        else
          Plurimath::Math::Function::Overset.new(overscript, base, options)
        end
      end

      # MathML element: <munder> base underscript
      def munder_to_underset(munder)
        children = content_children(munder)
        base = mml_to_plurimath(children[0])
        underscript = mml_to_plurimath(children[1])
        options = {}
        options[:accentunder] = true if truthy_mathml_bool?(munder.accentunder)

        if base.is_a?(Plurimath::Math::Function::Vec) ||
           (base.respond_to?(:is_ternary_function?) && base.is_ternary_function? && !base.any_value_exist?)
          base.parameter_one = underscript
          base.attributes = options if base.respond_to?(:attributes=)
          return base
        end

        if base.respond_to?(:is_binary_function?) && base.is_binary_function? && !base.any_value_exist?
          base.parameter_one = underscript
          return base
        end

        case underscript&.class_name
        when "obrace", "ubrace", "ul", "underline"
          underscript.parameter_one = base
          underscript
        when "bar"
          Plurimath::Math::Function::Ul.new(base, options)
        else
          Plurimath::Math::Function::Underset.new(underscript, base, options)
        end
      end

      # MathML element: <munderover> base underscript overscript
      def munderover_to_underover(munderover)
        children = content_children(munderover)
        base = filter_child(mml_to_plurimath(children[0]))
        underscript = filter_child(mml_to_plurimath(children[1]))
        overscript = filter_child(mml_to_plurimath(children[2]))

        if base&.is_ternary_function? && !base.any_value_exist?
          base.parameter_one = underscript
          base.parameter_two = overscript
          base
        elsif base&.is_nary_symbol?
          Plurimath::Math::Function::Nary.new(
            base,
            underscript,
            overscript,
            nil,
            { type: "undOvr" },
          )
        else
          Plurimath::Math::Function::Underover.new(base, underscript, overscript)
        end
      end

      # MathML element: <msup> base superscript
      def msup_to_power(sup)
        children = content_children(sup)
        base = filter_child(mml_to_plurimath(children[0]))
        superscript = filter_child(mml_to_plurimath(children[1]))
        if base&.is_binary_function? && !base.any_value_exist?
          base.parameter_one = superscript
          return base
        end

        Plurimath::Math::Function::Power.new(base, superscript)
      end

      # MathML element: <msub> base subscript
      def msub_to_base(sub)
        children = content_children(sub)
        base = filter_child(mml_to_plurimath(children[0]))
        subscript = filter_child(mml_to_plurimath(children[1]))
        if base&.is_binary_function? && !base.any_value_exist?
          base.parameter_one = subscript
          return base
        end

        Plurimath::Math::Function::Base.new(base, subscript)
      end

      # MathML element: <msubsup> base subscript superscript
      def msubsup_to_powerbase(subsup)
        children = content_children(subsup)
        base = filter_child(mml_to_plurimath(children[0]))
        subscript = filter_child(mml_to_plurimath(children[1]))
        superscript = filter_child(mml_to_plurimath(children[2]))

        if base&.is_ternary_function? && !base.any_value_exist?
          base.parameter_one = subscript
          base.parameter_two = superscript
          return base
        elsif base&.is_binary_function? && !base.any_value_exist?
          base.parameter_one = subscript
          base.parameter_two = superscript
          return base
        end

        Plurimath::Math::Function::PowerBase.new(base, subscript, superscript)
      end

      # MathML element: <mi> - identifier
      def mi_to_symbol(mi)
        value = text_value(mi.value)
        return nil if value.nil? || (value.respond_to?(:empty?) && value.empty?)

        apply_font_style(mi, mathml_symbol(value))
      end

      # MathML element: <mo> - operator
      def mo_to_symbol(mo)
        value = text_value(mo.value)
        # Handle linebreak="newline" attribute - creates a Linebreak wrapper
        if mo.linebreak == "newline"
          attributes = {}
          attributes[:linebreakstyle] = mo.linebreakstyle if mo.linebreakstyle
          symbol =
            if value.nil? || value == ""
              Plurimath::Math::Symbols::Symbol.new(nil)
            else
              mathml_symbol(value)
            end
          symbol = Plurimath::Math::Symbols::Symbol.new(value) if symbol.nil? || symbol.is_a?(Array)
          return Plurimath::Math::Function::Linebreak.new(
            symbol,
            attributes
          )
        end

        if value.nil? || value == ""
          result = Plurimath::Math::Symbols::Symbol.new(nil)
          options = {}
          options[:rspace] = mo.rspace if mo.respond_to?(:rspace) && mo.rspace
          result.options = options if options.any?
          return result
        end

        result = mathml_symbol(value)
        result = Plurimath::Math::Symbols::Symbol.new(value) if result.nil? || result.is_a?(Array)
        if result.instance_of?(Plurimath::Math::Symbols::Symbol)
          options = {}
          options[:rspace] = mo.rspace if mo.respond_to?(:rspace) && mo.rspace
          result.options = options if options.any?
        end
        apply_font_style(mo, result)
      end

      # MathML element: <mn> - number
      def mn_to_number(mn)
        value = text_value(mn.value) || ""
        Plurimath::Math::Number.new(value)
      end

      # MathML element: <mtext> - text
      def mtext_to_text(mtext)
        text_obj = Plurimath::Math::Function::Text.new
        text_obj.value = text_value(mtext.value)
        text_obj
      end

      # MathML element: <none>
      def none_to_none
        nil
      end

      # MathML element: <ms> - string
      def ms_to_ms(ms)
        children = ordered_children(ms)
        text_content = children.filter_map { |child| extract_ms_text(child) }.join(" ")
        Plurimath::Math::Function::Ms.new(text_content.empty? ? nil : text_content)
      end

      # MathML element: <mfrac> numerator denominator
      def mfrac_to_frac(frac)
        children = content_children(frac)
        numerator = mml_to_plurimath(children[0])
        denominator = mml_to_plurimath(children[1])
        options = {}
        options[:linethickness] = frac.linethickness if frac.linethickness
        options[:bevelled] = frac.bevelled if frac.bevelled
        Plurimath::Math::Function::Frac.new(numerator, denominator, options)
      end

      # MathML element: <msqrt> - square root
      def msqrt_to_sqrt(sqrt)
        children = content_children(sqrt)
        radicand = children.map { |child| mml_to_plurimath(child) }.compact
        radicand = radicand.first if radicand.size == 1
        Plurimath::Math::Function::Sqrt.new(radicand)
      end

      # MathML element: <mroot> radicand index
      def mroot_to_root(root)
        children = content_children(root)
        radicand = filter_child(mml_to_plurimath(children[0]))
        index = filter_child(mml_to_plurimath(children[1]))
        Plurimath::Math::Function::Root.new(index, radicand)
      end

      # MathML element: <mphantom> - phantom
      def mphantom_to_phantom(phantom)
        children = ordered_children(phantom)
        content = children.map { |child| mml_to_plurimath(child) }.compact
        content_obj = wrap_children(content)
        content_obj = normalize_phantom_child(content_obj)
        Plurimath::Math::Function::Phantom.new(content_obj)
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
        Plurimath::Math::Function::Merror.new(wrap_children(content))
      end

      # MathML element: <mstyle> - style
      def mstyle_to_mstyle(style)
        children = ordered_children(style)
        content = children.map { |child| mml_to_plurimath(child) }.compact
        content_obj = wrap_children(content)

        has_color = style.respond_to?(:mathcolor) && style.mathcolor && !style.mathcolor.empty?
        has_variant = style.respond_to?(:mathvariant) && style.mathvariant && !style.mathvariant.empty?

        if has_color
          content_obj = Plurimath::Math::Function::Color.new(
            Plurimath::Math::Function::Text.new(style.mathcolor),
            content_obj,
          )
        end

        if has_variant
          font_class = Plurimath::Utility::FONT_STYLES[style.mathvariant.to_sym]
          return font_class.new(content_obj, style.mathvariant) if font_class
        end

        return content_obj if has_color

        fill_ternary_third_values(content)
        Plurimath::Math::Formula::Mstyle.new(
          content,
          display_style: boolean_to_displaystyle(style.displaystyle),
        )
      end

      # MathML element: <mfenced> - fenced
      def mfenced_to_fenced(fenced)
        children = ordered_children(fenced)
        content = children.map { |child| mml_to_plurimath(child) }.compact.map { |child| filter_child(child) }
        open_value = fenced.open || default_fenced_open(fenced)
        close_value = fenced.close || default_fenced_close(fenced)

        Plurimath::Math::Function::Fenced.new(
          resolve_paren(open_value),
          content,
          resolve_paren(close_value),
          { separators: fenced.separators }.compact,
        )
      end

      # MathML element: <mtable> - table
      def mtable_to_table(table)
        table_content = ordered_children(table).filter_map { |row| mml_to_plurimath(row) }
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
        Plurimath::Math::Function::Stackrel.new(wrap_children(content))
      end

      # MathML element: <msrow> - stack row
      def msrow_to_formula(msrow)
        children = ordered_children(msrow)
        content = children.map { |child| mml_to_plurimath(child) }.compact
        return nil if content.empty?

        Plurimath::Math::Formula.new(content)
      end

      # MathML element: <msgroup> - group
      def msgroup_to_msgroup(sgroup)
        content = ordered_children(sgroup).filter_map do |child|
          if child.is_a?(String)
            next if child.strip.empty?

            Plurimath::Math::Function::Text.new(child)
          else
            mml_to_plurimath(child)
          end
        end
        Plurimath::Math::Function::Msgroup.new(content)
      end

      # MathML element: <msline> - line
      def msline_to_msline(sline)
        children = ordered_children(sline)
        content = children.map { |child| mml_to_plurimath(child) }.compact
        Plurimath::Math::Function::Msline.new(wrap_children(content))
      end

      # MathML element: <mpadded> - padded
      def mpadded_to_mpadded(padded)
        children = ordered_children(padded)
        content = children.map { |child| mml_to_plurimath(child) }.compact
        options = {}
        options[:height] = padded.height if padded.height
        options[:depth] = padded.depth if padded.depth
        options[:width] = padded.width if padded.width
        Plurimath::Math::Function::Mpadded.new(wrap_children(content), options)
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

        has_prescripts = !multiscripts.mprescripts_value.nil?
        element_order = multiscripts.element_order
        mpre_index = element_order.index { |el| el.name == "mprescripts" }

        if has_prescripts && mpre_index
          post_names = element_order[0...mpre_index].select { |el| el.node_type == :element }.map(&:name)
          post_element_count = post_names.size - 1

          base = convert_multiscript_child(children[0])
          post_children = children[1..post_element_count].map { |child| convert_multiscript_child(child) }
          pre_children = children[(post_element_count + 1)..-1].map { |child| convert_multiscript_child(child) }

          post_pairs = post_children.each_slice(2).to_a
          post_subs = post_pairs.map { |pair| pair[0] }
          post_sups = post_pairs.map { |pair| pair[1] if pair[1] }

          pre_pairs = pre_children.each_slice(2).to_a
          pre_subs = pre_pairs.map { |pair| pair[0] }.compact
          pre_sups = pre_pairs.map { |pair| pair[1] if pair[1] }.compact

          base_with_posts =
            if post_subs.any? || post_sups.any?
              Plurimath::Math::Function::PowerBase.new(
                filter_child(base),
                unwrap_single(post_subs),
                unwrap_single(post_sups),
              )
            else
              filter_child(base)
            end

          Plurimath::Math::Function::Multiscript.new(base_with_posts, pre_subs, pre_sups)
        else
          base = convert_multiscript_child(children[0])
          remaining = children[1..-1].map { |child| convert_multiscript_child(child) }
          pairs = remaining.each_slice(2).to_a
          subscripts = pairs.map { |pair| pair[0] if pair[0] }.compact
          superscripts = pairs.map { |pair| pair[1] if pair[1] }.compact
          base_with_posts =
            if subscripts.any? || superscripts.any?
              Plurimath::Math::Function::PowerBase.new(
                filter_child(base),
                unwrap_single(subscripts),
                unwrap_single(superscripts),
              )
            else
              filter_child(base)
            end

          Plurimath::Math::Function::Multiscript.new(base_with_posts)
        end
      end

      # MathML element: <mlabeledtr> - labeled row
      def mlabeledtr_to_mlabeledtr(labeledtr)
        children = ordered_children(labeledtr)
        content = children.map { |child| mml_to_plurimath(child) }.compact
        label = labeledtr.id && Plurimath::Math::Function::Text.new(labeledtr.id)
        Plurimath::Math::Function::Mlabeledtr.new(content, label)
      end

      # MathML element: <semantics> - semantics
      def semantics_to_semantics(semantics)
        children = ordered_children(semantics)
        content = filter_child(wrap_children(children.map { |child| mml_to_plurimath(child) }.compact))
        annotations = []
        annotations += build_annotation_entries(semantics.annotation_value, :annotation)
        annotations += build_annotation_entries(semantics.annotation_xml_value, :"annotation-xml")
        Plurimath::Math::Function::Semantics.new(content, annotations.empty? ? nil : annotations)
      end

      # MathML element: <mscarries> - carries
      def mscarries_to_scarries(scarries)
        children = ordered_children(scarries)
        content = children.map { |child| mml_to_plurimath(child) }.compact
        Plurimath::Math::Function::Scarries.new(wrap_children(content))
      end

      # MathML element: <mscarry> - carry
      # The legacy MathML flow treated <mscarry> as a layout marker inside
      # <mscarries>, so it was removed before AST construction.
      def mscarry_to_mscarry(_scarry)
        nil
      end

      # MathML element: <mprescripts> - prescripts marker
      # This is a marker element, returns nil (filtered out)
      def mprescripts_to_prescripts(_)
        nil
      end

      # MathML element: <mspace> - space
      def mspace_to_space(space)
        if space.linebreak && !space.linebreak.empty?
          Plurimath::Math::Function::Linebreak.new(
            nil,
            { linebreak: space.linebreak },
          )
        end
      end

      def text_node_to_plurimath(text)
        return nil if text.nil? || text.match?(/\A[[:space:]]*\z/)

        mathml_symbol(text)
      end

      def default_fenced_open(fenced)
        "(" unless fenced.close
      end

      def default_fenced_close(fenced)
        ")" unless fenced.open
      end

      def resolve_paren(value)
        return nil unless value

        mathml_symbol(value)
      end

      def extract_ms_text(node)
        return (node.empty? ? nil : node) if node.is_a?(String)

        if ms_token_element?(node)
          return Array(node.value).join
        end

        if node.respond_to?(:each_mixed_content)
          return ordered_children(node).filter_map { |child| extract_ms_text(child) }.join(" ")
        end

        Array(node.value).join if node.respond_to?(:value)
      end

      def ms_token_element?(node)
        node.is_a?(Mml::V4::Mi) ||
          node.is_a?(Mml::V4::Mn) ||
          node.is_a?(Mml::V4::Mo) ||
          node.is_a?(Mml::V4::Ms) ||
          node.is_a?(Mml::V4::Mtext)
      end

      def normalize_phantom_child(child)
        return child unless child.respond_to?(:value=) && child.respond_to?(:value)
        return child if child.instance_of?(Plurimath::Math::Symbols::Symbol)
        return child unless child.value.is_a?(String)
        return child unless child.value.match?(/\A[[:space:]]|[[:space:]]\z/)

        child.value = nil
        child
      end

      def boolean_to_displaystyle(value)
        case value
        when "true", true then true
        when "false", false then false
        else true
        end
      end

      def truthy_mathml_bool?(value)
        value == true || value == "true"
      end

      def filter_child(value)
        return nil if value.nil?
        return value unless value.is_a?(Plurimath::Math::Formula)
        return value if value.value.nil? || value.value.empty?

        value.value.length == 1 ? value.value.first : value
      end

      def wrap_children(children)
        case children.length
        when 0 then nil
        when 1 then children.first
        else Plurimath::Math::Formula.new(children)
        end
      end

      def nary_check(children)
        return children unless children.length == 2

        first = children.first
        second = children.last

        if first.is_a?(Plurimath::Math::Function::PowerBase) && first.parameter_one&.is_nary_symbol?
          [Plurimath::Math::Function::Nary.new(
            first.parameter_one,
            first.parameter_two,
            first.parameter_three,
            second,
          )]
        elsif first.is_a?(Plurimath::Math::Function::Overset) && first.parameter_two&.is_nary_symbol?
          [Plurimath::Math::Function::Nary.new(
            first.parameter_two,
            nil,
            first.parameter_one,
            second,
            { type: "undOvr" },
          )]
        elsif first.is_a?(Plurimath::Math::Function::Power) && first.parameter_one&.is_nary_symbol?
          [Plurimath::Math::Function::Nary.new(
            first.parameter_one,
            nil,
            first.parameter_two,
            second,
            { type: "subSup" },
          )]
        else
          children
        end
      end

      def fill_ternary_third_values(values)
        return unless values.is_a?(Array) && values.length > 1

        first = values.first
        return if preserve_separate_nary_body?(first, values[1])

        if first.is_a?(Plurimath::Math::Function::Nary)
          first.parameter_four ||= values.delete_at(1)
        elsif first.respond_to?(:is_nary_function?) && first.is_nary_function? && !first.all_values_exist?
          if first.respond_to?(:new_nary_function) && !first.any_value_exist?
            values[0] = first.new_nary_function(values.delete_at(1))
          elsif first.any_value_exist?
            first.parameter_three = values.delete_at(1)
          end
        elsif value_is_ternary_or_nary?(values)
          first.parameter_three = values.delete_at(1)
        end
      end

      def unwrap_single(value)
        return nil if value.nil? || (value.is_a?(Array) && value.empty?)
        return value unless value.is_a?(Array)

        value.length == 1 ? value.first : Plurimath::Math::Formula.new(value)
      end

      def preserve_separate_nary_body?(first, second)
        return false unless first.respond_to?(:is_nary_function?) && first.is_nary_function?

        normalized_second = filter_child(second)

        normalized_second.is_a?(Plurimath::Math::Function::Base) ||
          normalized_second.is_a?(Plurimath::Math::Function::PowerBase)
      end

      def preserve_explicit_nary_body!(values)
        return unless values.is_a?(Array) && values.any?

        first = values.first
        return unless first.is_a?(Plurimath::Math::Function::Nary)
        return unless first.options&.[](:type) == "undOvr"

        body = filter_child(first.parameter_four)
        return unless body.is_a?(Plurimath::Math::Function::Base) ||
                      body.is_a?(Plurimath::Math::Function::PowerBase)

        replacement =
          if first.parameter_three.nil?
            Plurimath::Math::Function::Underset.new(first.parameter_two, first.parameter_one)
          else
            Plurimath::Math::Function::Underover.new(
              first.parameter_one,
              first.parameter_two,
              first.parameter_three,
            )
          end

        values[0] = replacement
        values.insert(1, body)
      end

      def convert_multiscript_child(child)
        return Plurimath::Math::Function::None.new if child.is_a?(Mml::V4::None) || child.is_a?(Mml::V3::None)
        return Plurimath::Math::Function::None.new if child.respond_to?(:value) && Array(child.value).join.empty?

        mml_to_plurimath(child) || Plurimath::Math::Function::None.new
      end

      def build_annotation_entries(entries, tag_name)
        return [] unless entries&.any?

        entries.map do |annotation|
          value = annotation.respond_to?(:value) ? annotation.value : annotation.to_s
          { tag_name => [Plurimath::Math::Symbols::Symbol.new(value)] }
        end
      end

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
              # Use the existing Paren object if available, otherwise create a Paren::Lround
              paren = if next_elem.respond_to?(:paren?) && next_elem.paren?
                        next_elem
                      else
                        Plurimath::Math::Symbols::Paren::Lround.new
                      end
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

      def apply_font_style(element, result)
        return result unless element.respond_to?(:mathvariant)

        variant = element.mathvariant
        return result if variant.nil? || variant.empty?

        font_class = Plurimath::Utility::FONT_STYLES[variant.to_sym]
        return result unless font_class

        font_class.new(result, variant)
      end
    end
  end
end
