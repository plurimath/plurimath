# frozen_string_literal: true

require "parslet"
module Plurimath
  class Omml
    class Transform < Parslet::Transform
      rule(e: subtree(:e))  { e.flatten.compact }
      rule(r: subtree(:r))  { r.is_a?(Array) ? r.flatten.compact : r }
      rule(i: sequence(:i)) { i.empty? ? nil : i }
      rule(t: sequence(:t)) { Utility.text_classes(t) }
      rule(mc: sequence(:mc))  { nil }
      rule(bar: simple(:bar))  { bar }
      rule(rad: simple(:rad))  { rad }
      rule(acc: simple(:acc))  { acc }
      rule(sty: simple(:sty))  { nil }
      rule(val: simple(:val))  { val }
      rule(pos: simple(:pos))  { pos }
      rule(rPr: subtree(:rpr)) { rpr }
      rule(fPr: subtree(:fpr)) { fpr }
      rule(num: subtree(:num)) { num }
      rule(den: subtree(:den)) { den }
      rule(mPr: subtree(:mPr)) { nil }
      rule(sSup: simple(:sup)) { sup }
      rule(sSub: simple(:sub)) { sub }
      rule(box: subtree(:box)) { box.flatten.compact }
      rule(nor: sequence(:nor))   { nil }
      rule(mcs: sequence(:mcs))   { nil }
      rule(lim: sequence(:lim))   { lim.flatten.compact }
      rule(nary: simple(:nary))   { nary }
      rule(sPre: simple(:sPre))   { sPre }
      rule(func: simple(:func))   { func }
      rule(mcJc: simple(:mcJc))   { nil }
      rule(argPr: subtree(:arg))  { nil }
      rule(boxPr: subtree(:box))  { nil }
      rule(mcPr: sequence(:mcPr)) { nil }
      rule(count: simple(:count)) { nil }
      rule(argSz: simple(:argsz)) { nil }
      rule(oMath: subtree(:math)) { math }
      rule(oMath: sequence(:math))    { math }
      rule(rFonts: simple(:fonts))    { nil }
      rule(limLoc: simple(:limLoc))   { limLoc }
      rule(limLow: simple(:limLow))   { limLow }
      rule(begChr: simple(:begChr))   { Math::Symbol.new(begChr) }
      rule(endChr: simple(:endChr))   { Math::Symbol.new(endChr) }
      rule(limLoc: subtree(:limLoc))  { limLoc }
      rule(ctrlPr: subtree(:ctrlpr))  { ctrlpr.flatten.compact }
      rule(sSubSup: simple(:sSubSup)) { sSubSup }
      rule(degHide: simple(:degHide)) { [] }
      rule(subHide: simple(:subHide)) { [] }
      rule(supHide: simple(:supHide)) { [] }
      rule(eqArrPr: subtree(:eqarrpr))    { eqarrpr.flatten.compact }
      rule(groupChr: simple(:groupChr))   { groupChr }
      rule(limUppPr: subtree(:limUppPr))  { limUppPr.flatten.compact }
      rule(sequence: subtree(:sequence))  { sequence.flatten.compact }
      rule(borderBox: simple(:borderBox)) { borderBox }
      rule(sequence: sequence(:sequence)) { sequence.flatten.compact }

      rule(m: sequence(:m)) do
        Math::Function::Table.new(
          m.flatten.compact,
        )
      end

      rule(f: subtree(:f)) do
        Math::Function::Frac.new(
          Utility.filter_values(f[1]),
          Utility.filter_values(f[2]),
        )
      end

      rule(mr: subtree(:mr)) do
        row = []
        mr.flatten.compact.each do |td|
          row << Math::Function::Td.new([td])
        end
        Math::Function::Tr.new(row)
      end

      rule(d: subtree(:data)) do
        d = data.flatten.compact
        if d.is_a?(Array)
          open_paren  = d.shift if d.first.class_name == "symbol"
          close_paren = d.pop if d.last.class_name == "symbol"
          fenced = d.flatten.compact
        end
        Math::Function::Fenced.new(
          open_paren,
          fenced,
          close_paren,
        )
      end

      rule(limUpp: subtree(:limUpp)) do
        lim_values = limUpp.flatten.compact
        Math::Function::Overset.new(
          lim_values[0],
          lim_values[1],
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

      rule(ascii: simple(:ascii),
           eastAsiaTheme: simple(:eastAsiaTheme),
           hAnsi: simple(:hansi)) do
        nil
      end

      rule(ascii: simple(:ascii),
           eastAsia: simple(:eastAsia),
           hAnsi: simple(:hansi),
           cs: simple(:cs)) do
        nil
      end

      rule(rPr: sequence(:rpr),
           t: sequence(:t)) do
        Utility.text_classes(t)
      end

      rule(barPr: subtree(:barpr),
           e: sequence(:e)) do
        if barpr&.flatten&.compact&.include?("top")
          Math::Function::Bar.new(
            Utility.filter_values(e)
          )
        else
          Math::Function::Ul.new(
            Utility.filter_values(e)
          )
        end
      end

      rule(borderBoxPr: subtree(:borderBoxpr),
           e: sequence(:e)) do
        Math::Function::Menclose.new(
          "longdiv",
          Utility.filter_values(e),
        )
      end

      rule(groupChrPr: subtree(:groupChrPr),
           e: sequence(:e)) do
        value        = groupChrPr.flatten.compact
        symbol_value = value.find { |a| a.key?(:chr) }
        if value&.include?("top")
          Math::Function::Overset.new(
            Utility.filter_values(e),
            Math::Symbol.new(symbol_value ? symbol_value[:chr] : ""),
          )
        else
          Math::Function::Underset.new(
            Math::Symbol.new(symbol_value ? symbol_value[:chr] : "⏟"),
            Utility.filter_values(e),
          )
        end
      end

      rule(accPr: subtree(:accpr),
           e: sequence(:e)) do
        first_value  = Utility.filter_values(e)
        second_value = if accpr.flatten.compact.empty?
                         Math::Symbol.new("^")
                       else
                         first = accpr.find { |a| a.key?(:chr) }[:chr]
                         Utility.text_classes(first)
                       end
        Math::Function::Overset.new(
          first_value,
          second_value,
        )
      end

      rule(rPr: sequence(:rpr),
           lastRenderedPageBreak: sequence(:lastRenderedPageBreak),
           t: sequence(:t)) do
        Utility.text_classes(t)
      end

      rule(limLowPr: subtree(:limLowpr),
           e: sequence(:e),
           lim: sequence(:lim)) do
        Math::Function::Underset.new(
          Utility.filter_values(lim),
          Utility.filter_values(e),
        )
      end

      rule(dPr: subtree(:dpr),
           e: sequence(:e)) do
        if dpr.flatten.compact.length.zero?
          e
        else
          dpr.flatten.compact.insert(1, e)
        end
      end

      rule(fPr: subtree(:fpr),
           num: subtree(:num),
           den: subtree(:den)) do
        [fpr, num, den]
      end

      rule(funcPr: subtree(:funcpr),
           fName: subtree(:fName),
           e: subtree(:e)) do
        if fName.first.is_a?(Math::Function::Text)
          unary_class = Utility.get_class(fName.first.parameter_one)
          unary_class.new(Utility.filter_values(e))
        else
          Math::Formula.new(fName + e)
        end
      end

      rule(sSupPr: subtree(:sSuppr),
           e: subtree(:e),
           sup: subtree(:sup)) do
        Math::Function::Power.new(
          Utility.filter_values(e),
          Utility.filter_values(sup),
        )
      end

      rule(sSubPr: subtree(:sSuppr),
           e: subtree(:e),
           sub: subtree(:sub)) do
        Math::Function::Base.new(
          Utility.filter_values(e),
          Utility.filter_values(sub),
        )
      end

      rule(radPr: subtree(:radpr),
           deg: sequence(:deg),
           e: sequence(:e)) do
        if deg.empty?
          Math::Function::Sqrt.new(
            Utility.filter_values(e),
          )
        else
          Math::Function::Root.new(
            Utility.filter_values(deg),
            Utility.filter_values(e),
          )
        end
      end

      rule(sPrePr: subtree(:sPrepr),
           sub: sequence(:sub),
           sup: sequence(:sup),
           e: sequence(:e)) do
        Math::Function::Multiscript.new(
          Utility.filter_values(e),
          Utility.filter_values(sub),
          Utility.filter_values(sup),
        )
      end

      rule(sSubSupPr: subtree(:sSubSuppr),
           e: subtree(:e),
           sub: subtree(:sub),
           sup: subtree(:sup)) do
        Math::Function::PowerBase.new(
          Utility.filter_values(e),
          Utility.filter_values(sub),
          Utility.filter_values(sup),
        )
      end

      rule(naryPr: subtree(:narypr),
           sub: sequence(:sub),
           sup: sequence(:sup),
           e: sequence(:e)) do
        nary   = narypr&.flatten&.compact
        values = nary.find { |a| a.is_a?(Hash) }
        fonts  = Math::Symbol.new(values ? nary.delete(values)[:chr] : "∫")
        limloc = Utility.filter_values(nary)
        nary_class = if limloc == "undOvr"
                       Math::Function::Underover
                     else
                       Math::Function::PowerBase
                     end
        first_formula = if sub.empty? && sup.empty?
                          fonts
                        else
                          nary_class.new(
                            fonts,
                            Utility.filter_values(sub),
                            Utility.filter_values(sup),
                          )
                        end
        Utility.parse_nary_tag(first_formula, e)
      end
    end
  end
end
