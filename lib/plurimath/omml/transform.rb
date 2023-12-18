# frozen_string_literal: true

require "parslet"
module Plurimath
  class Omml
    class Transform < Parslet::Transform
      rule(t: simple(:t))   { Utility.text_classes(t) }
      rule(e: subtree(:e))  { e.flatten.compact }
      rule(i: sequence(:i)) { i }
      rule(e: sequence(:e)) { e.flatten.compact }

      rule(br: sequence(:br))    { Math::Function::Linebreak.new }
      rule(val: simple(:val))    { val }
      rule(scr: simple(:scr))    { scr }
      rule(sty: simple(:sty))    { sty }
      rule(num: subtree(:num))   { num }
      rule(den: subtree(:den))   { den }
      rule(fPr: subtree(:fPr))   { nil }
      rule(mpr: subtree(:mpr))   { nil }
      rule(mPr: subtree(:mPr))   { nil }
      rule(box: subtree(:box))   { box.flatten.compact }
      rule(deg: sequence(:deg))  { Utility.filter_values(deg) }
      rule(sub: sequence(:sub))  { Utility.filter_values(sub) }
      rule(sup: sequence(:sup))  { Utility.filter_values(sup) }
      rule(boxPr: subtree(:box)) { nil }
      rule(argPr: subtree(:arg)) { nil }
      rule(accPr: subtree(:acc)) { acc.flatten.compact }

      rule(sSubPr: subtree(:arg))   { nil }
      rule(space: simple(:space))   { space }
      rule(radPr: subtree(:radpr))  { nil }
      rule(barPr: subtree(:barpr))  { barpr }
      rule(oMath: subtree(:omath))  { omath.flatten.compact }
      rule(fName: subtree(:fname))  { fname }
      rule(oMath: sequence(:omath)) { omath }
      rule(limLoc: simple(:limLoc)) { limLoc }

      rule(rFonts: subtree(:rFonts))   { nil }
      rule(sSupPr: subtree(:ssuppr))   { nil }
      rule(sPrePr: subtree(:sprepr))   { nil }
      rule(funcPr: subtree(:funcpr))   { nil }
      rule(naryPr: subtree(:narypr))   { narypr }
      rule(subHide: simple(:subHide))  { nil }
      rule(supHide: simple(:supHide))  { nil }
      rule(degHide: simple(:degHide))  { nil }
      rule(ctrlPr: sequence(:ctrlpr))  { ctrlpr }
      rule(eqArrPr: subtree(:eqarrpr)) { eqarrpr.flatten.compact }

      rule(sequence: subtree(:sequence))   { sequence.flatten.compact }
      rule(limUppPr: subtree(:limUppPr))   { nil }
      rule(limLowPr: subtree(:limLowpr))   { nil }
      rule(sequence: sequence(:sequence))  { sequence }
      rule(sSubSupPr: subtree(:sSubSuppr)) { nil }

      rule(groupChrPr: subtree(:groupchrpr))   { groupchrpr }
      rule(borderBoxPr: subtree(:borderBoxpr)) { nil }
      rule(lastRenderedPageBreak: sequence(:break)) { nil }

      rule(f: subtree(:f)) do
        Math::Function::Frac.new(
          Utility.filter_values(f[1]),
          Utility.filter_values(f[2]),
        )
      end

      rule(r: subtree(:r)) do
        flatten_row = r&.flatten&.compact
        if flatten_row.empty?
          nil
        elsif flatten_row.length > 1 && !flatten_row.first.is_a?(Math::Core)
          font = flatten_row.shift
          font.new(
            Utility.filter_values(flatten_row),
            Utility::FONT_STYLES.key(font).to_s,
          )
        else
          Utility.filter_values(flatten_row)
        end
      end

      rule(m: sequence(:m)) do
        Math::Function::Table.new(
          m.flatten.compact,
        )
      end

      rule(t: sequence(:t)) do
        if t.empty?
          Math::Function::Text.new
        else
          t&.compact&.empty? ? [nil] : Utility.mathml_unary_classes(t, omml: true)
        end
      end

      rule(d: subtree(:data)) do
        fenced = data.shift
        fenced_value = data.flatten.compact
        if data.length == 1 && data.flatten.compact.first.is_a?(Math::Function::Table)
          fenced_value.first.open_paren = fenced&.parameter_one&.value
          fenced_value.first.close_paren = fenced&.parameter_three&.value
          data
        else
          fenced.parameter_two = data.flatten.compact
          fenced
        end
      end

      rule(dPr: subtree(:dpr)) do
        flatten_dpr = dpr.flatten.compact
        open_paren  = flatten_dpr.find { |hash| hash[:begChr] }&.values&.first
        close_paren = flatten_dpr.find { |hash| hash[:endChr] }&.values&.first
        sep_chr     = flatten_dpr.find { |hash| hash[:sepChr] }
        open_paren_object = Utility.symbol_object(open_paren) if open_paren
        close_paren_object = Utility.symbol_object(close_paren) if close_paren
        fenced = Math::Function::Fenced.new(
          open_paren_object,
          nil,
          close_paren_object,
        )
        fenced.options = sep_chr
        fenced
      end

      rule(mtd: sequence(:mtd)) do
        flatten_mtd = mtd&.flatten&.compact
        if flatten_mtd.length > 1 && !flatten_mtd.first.is_a?(Math::Core)
          font = flatten_mtd.shift
          font.new(
            Utility.filter_values(flatten_mtd),
            Utility::FONT_STYLES.rassoc(font).first.to_s,
          )
        else
          flatten_mtd
        end
      end

      rule(mr: subtree(:mr)) do
        row = []
        mr.each do |td|
          row << Math::Function::Td.new(Array(td))
        end
        Math::Function::Tr.new(row)
      end

      rule(rPr: subtree(:rpr)) do
        if rpr.is_a?(Array)
          Utility::FONT_STYLES[
            Omml::Parser::SUPPORTED_FONTS[
              rpr&.join("-")&.to_sym,
            ]&.to_sym,
          ]
        end
      end

      rule(lim: sequence(:lim)) do
        if lim.any?(String)
          Utility.text_classes(lim)
        else
          Utility.filter_values(lim)
        end
      end

      rule(acc: subtree(:acc)) do
        acc_value = acc.flatten.compact
        chr = Utility.find_pos_chr(acc_value, :chr)
        chr_value = chr ? chr[:chr] : Math::Function::Hat.new
        index = acc_value.index { |d| d[:chr] }
        acc_value[index] = chr_value
        Utility.unary_function_classes(acc_value)
        acc_value.first.attributes = { accent: true }
        acc_value.first
      end

      rule(func: subtree(:func)) do
        Utility.filter_values(
          Utility.populate_function_classes(func),
        )
      end

      rule(nary: subtree(:nary)) do
        flatten_nary = nary.flatten.compact
        chr = Utility.find_pos_chr(flatten_nary, :chr)
        ternary_class = Utility.mathml_unary_classes(chr.values) if chr
        if ternary_class.is_a?(Math::Function::TernaryFunction)
          ternary_class.parameter_one = Utility.filter_values(nary[1])
          ternary_class.parameter_two = Utility.filter_values(nary[2])
          ternary_class.parameter_three = Utility.filter_values(nary[3])
          ternary_class
        else
          Utility.nary_fonts(nary)
        end
      end

      rule(groupChr: subtree(:groupchr)) do
        chr_pos = groupchr.first
        pos = Utility.find_pos_chr(chr_pos, :pos)
        chr = Utility.find_pos_chr(chr_pos, :chr)
        if pos&.value?("top")
          Math::Function::Overset.new(
            Math::Symbol.new(chr ? chr[:chr] : ""),
            Utility.filter_values(groupchr[1]),
          )
        else
          Math::Function::Underset.new(
            Math::Symbol.new(chr ? chr[:chr] : "⏟"),
            Utility.filter_values(groupchr[1]),
          )
        end
      end

      rule(sSubSup: subtree(:sSubSup)) do
        subsup = sSubSup.flatten.compact
        subsup.each_with_index do |object, ind|
          subsup[ind] = Utility.mathml_unary_classes([object]) if object.is_a?(String)
        end
        if Utility.valid_class(subsup[0])
          Utility.get_class(
            subsup[0].extract_class_name_from_text,
          ).new(
            subsup[1],
            subsup[2],
          )
        else
          Math::Function::PowerBase.new(
            subsup[0],
            subsup[1],
            subsup[2],
          )
        end
      end

      rule(sSup: subtree(:ssup)) do
        sup = ssup.flatten.compact
        Math::Function::Power.new(
          sup[0],
          sup[1],
        )
      end

      rule(rad: subtree(:rad)) do
        if rad[1].nil?
          Math::Function::Sqrt.new(
            Utility.filter_values(rad[2]),
          )
        else
          Math::Function::Root.new(
            Utility.filter_values(rad[2]),
            rad[1],
          )
        end
      end

      rule(sSub: subtree(:ssub)) do
        sub = ssub.flatten.compact
        Math::Function::Base.new(
          sub[0],
          sub[1],
        )
      end

      rule(limUpp: subtree(:lim)) do
        lim_values = lim.flatten.compact
        first_value = lim_values[0]
        if lim.last.is_unary? && lim.last.value_nil?
          function_class = lim.pop
          function_class.parameter_one = Utility.filter_values(lim.flatten.compact)
          function_class
        else
          Math::Function::Overset.new(
            first_value,
            lim_values[1],
          )
        end
      end

      rule(limLow: subtree(:lim)) do
        second_value = Utility.filter_values(lim[2])
        unicode = Mathml::Constants::UNICODE_SYMBOLS.invert[second_value&.class_name]
        second_value = unicode ? Math::Symbol.new(unicode.to_s) : second_value
        if second_value.is_unary? && second_value.value_nil?
          second_value.parameter_one = Utility.filter_values(lim[1])
          second_value
        else
          Math::Function::Underset.new(
            Utility.filter_values(lim[1]),
            second_value,
          )
        end
      end

      rule(borderBox: subtree(:box)) do
        Math::Function::Menclose.new(
          "longdiv",
          Utility.filter_values(box[1]),
        )
      end

      rule(bar: subtree(:bar)) do
        flatten_bar = bar.flatten.compact
        attrs = { accent: false }
        Math::Function::Bar.new(flatten_bar.last, attrs)
      end

      rule(sPre: subtree(:spre)) do
        pre = spre.flatten.compact
        Math::Function::Multiscript.new(
          pre[2],
          pre[0],
          pre[1],
        )
      end

      rule(eqArr: subtree(:eqArr)) do
        table_value = []
        eqArr.delete_at(0)
        eqArr.each do |value|
          table_value << Math::Function::Tr.new(
            [
              Math::Function::Td.new(
                Array(value),
              ),
            ],
          )
        end
        Math::Function::Table.new(table_value)
      end

      rule(ascii: simple(:ascii),
           hAnsi: simple(:hansi)) do
        nil
      end

      rule(attributes: simple(:attributes), value: sequence(:value)) do
        if value.any? || attributes == "preserve"
          value.any? ? value : [" "]
        else
          attributes
        end
      end
    end
  end
end
