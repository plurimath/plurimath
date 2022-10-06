# frozen_string_literal: true

require "parslet"
module Plurimath
  class Omml
    class Transform < Parslet::Transform
      rule(t: simple(:t))   { Utility.text_classes(t) }
      rule(e: subtree(:e))  { e.flatten.compact }
      rule(i: sequence(:i)) { i }
      rule(t: sequence(:t)) { Utility.text_classes(t) }
      rule(e: sequence(:e)) { e.flatten.compact }

      rule(val: simple(:val))   { val }
      rule(dPr: subtree(:dpr))  { dpr }
      rule(num: subtree(:num))  { num }
      rule(den: subtree(:den))  { den }
      rule(rPr: subtree(:rPr))  { nil }
      rule(fPr: subtree(:fPr))  { nil }
      rule(mPr: subtree(:mPr))  { nil }
      rule(box: subtree(:box))  { box.flatten.compact }
      rule(lim: sequence(:lim)) { Utility.filter_values(lim) }
      rule(deg: sequence(:deg)) { Utility.filter_values(deg) }
      rule(sub: sequence(:sub)) { Utility.filter_values(sub) }
      rule(sup: sequence(:sup)) { Utility.filter_values(sup) }

      rule(boxPr: subtree(:box))   { nil }
      rule(sSubPr: subtree(:arg))  { nil }
      rule(space: simple(:space))  { space }
      rule(radPr: subtree(:radpr)) { nil }
      rule(barPr: subtree(:barpr)) { barpr }
      rule(oMath: subtree(:omath)) { omath.flatten.compact }
      rule(fName: subtree(:fname)) { fname }

      rule(oMath: sequence(:omath))    { omath }
      rule(limLoc: simple(:limLoc))    { limLoc }
      rule(begChr: simple(:begChr))    { Math::Symbol.new(begChr) }
      rule(endChr: simple(:endChr))    { Math::Symbol.new(endChr) }
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

      rule(f: subtree(:f)) do
        Math::Function::Frac.new(
          Utility.filter_values(f[1]),
          Utility.filter_values(f[2]),
        )
      end

      rule(r: sequence(:r)) do
        Math::Formula.new(
          r.flatten.compact,
        )
      end

      rule(m: sequence(:m)) do
        Math::Function::Table.new(
          m.flatten.compact,
        )
      end

      rule(d: subtree(:data)) do
        fenced       = data.flatten.compact
        open_paren   = fenced.shift if fenced.first.class_name == "symbol"
        close_paren  = fenced.shift if fenced.first.class_name == "symbol"
        fenced_value = fenced
        Math::Function::Fenced.new(
          open_paren,
          fenced_value,
          close_paren,
        )
      end

      rule(mr: subtree(:mr)) do
        row = []
        mr.flatten.compact.each do |td|
          row << Math::Function::Td.new([td])
        end
        Math::Function::Tr.new(row)
      end

      rule(func: subtree(:func)) do
        func_name = func.flatten.compact
        class_object = Utility.find_class_name(func_name.first)
        if class_object
          class_object.new(func_name.last)
        else
          Math::Formula.new(
            func_name,
          )
        end
      end

      rule(nary: subtree(:nary)) do
        Math::Formula.new(
          [
            Utility.nary_fonts(nary),
            Utility.filter_values(nary[3]),
          ],
        )
      end

      rule(groupChr: subtree(:groupchr)) do
        chr_pos = groupchr.first
        pos = Utility.find_pos_chr(chr_pos, :pos)
        chr = Utility.find_pos_chr(chr_pos, :chr)
        if pos&.value?("top")
          Math::Function::Overset.new(
            Utility.filter_values(groupchr[1]),
            Math::Symbol.new(chr ? chr[:chr] : ""),
          )
        else
          Math::Function::Underset.new(
            Utility.filter_values(groupchr[1]),
            Math::Symbol.new(chr ? chr[:chr] : "⏟"),
          )
        end
      end

      rule(sSubSup: subtree(:sSubSup)) do
        subsup = sSubSup.flatten.compact
        Math::Function::PowerBase.new(
          subsup[0],
          subsup[1],
          subsup[2],
        )
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
        Plurimath::Math::Function::Base.new(
          sub[0],
          sub[1],
        )
      end

      rule(limUpp: subtree(:limUpp)) do
        lim_values = limUpp.flatten.compact
        first_value = lim_values[0]
        Math::Function::Overset.new(
          first_value,
          lim_values[1],
        )
      end

      rule(limLow: subtree(:lim)) do
        Math::Function::Underset.new(
          Utility.filter_values(lim[1]),
          Utility.filter_values(lim[2]),
        )
      end

      rule(borderBox: subtree(:box)) do
        Math::Function::Menclose.new(
          "longdiv",
          Utility.filter_values(box[1]),
        )
      end

      rule(bar: subtree(:bar)) do
        barpr = bar&.flatten&.compact
        pospr = Utility.find_pos_chr(bar.first, :pos)
        class_name = if pospr&.value?("top")
                       Math::Function::Bar
                     else
                       Math::Function::Ul
                     end
        class_name.new(barpr.last)
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
        eqArr.flatten.compact.each do |value|
          table_value << Math::Function::Tr.new(
            [
              Math::Function::Td.new(
                [
                  value,
                ],
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
