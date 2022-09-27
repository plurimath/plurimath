# frozen_string_literal: true

require "parslet"
module Plurimath
  class Omml
    class Transform < Parslet::Transform
      rule(e: subtree(:e))  { e.flatten.compact }
      rule(r: subtree(:r))  { r.is_a?(Array) ? r.flatten.compact : r }
      rule(i: sequence(:i)) { i.empty? ? nil : i }
      rule(t: sequence(:t)) { Transform.text_classes(t) }
      rule(rad: simple(:rad))  { rad }
      rule(acc: simple(:acc))  { acc }
      rule(sty: simple(:sty))  { nil }
      rule(val: simple(:val))  { val }
      rule(rPr: subtree(:rpr)) { rpr }
      rule(fPr: subtree(:fpr)) { fpr }
      rule(num: subtree(:num)) { num }
      rule(den: subtree(:den)) { den }
      rule(sSup: simple(:sup)) { sup }
      rule(sSub: simple(:sub)) { sub }
      rule(box: subtree(:box)) { box.flatten.compact }
      rule(lim: sequence(:lim))   { lim.flatten.compact }
      rule(nary: simple(:nary))   { nary }
      rule(sPre: simple(:sPre))   { sPre }
      rule(func: simple(:func))   { func }
      rule(argPr: subtree(:arg))  { nil }
      rule(boxPr: subtree(:box))  { nil }
      rule(argSz: simple(:argsz)) { nil }
      rule(oMath: subtree(:math)) { math }
      rule(oMath: sequence(:math))    { math }
      rule(rFonts: simple(:fonts))    { nil }
      rule(limLoc: simple(:limLoc))   { limLoc }
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
      rule(sequence: sequence(:sequence)) { sequence.flatten.compact }

      rule(f: subtree(:f)) do
        Math::Function::Frac.new(
          Transform.filter_values(f[1]),
          Transform.filter_values(f[2]),
        )
      end

      rule(d: subtree(:d)) do
        if d.is_a?(Array)
          open_paren  = d.shift if d.first.class_name == "symbol"
          close_paren = d.pop if d.last.class_name == "symbol"
          fenced = d.flatten.compact
        else
          fenced = [d]
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

      rule(rPr: sequence(:rpr),
           t: sequence(:t)) do
        Transform.text_classes(t)
      end

      rule(groupChrPr: subtree(:groupChrPr),
           e: sequence(:e)) do
        value = groupChrPr.flatten.compact
        attrs = value.find { |a| a.key?(:pos) }
        if attrs&.value?("top")
          Math::Function::Overset.new(
            Transform.filter_values(e),
            Math::Symbol.new(
              groupChrPr.find { |a| a.key?(:chr) }[:chr],
            ),
          )
        elsif value.empty?
          Math::Function::Underset.new(
            Math::Symbol.new("⏟"),
            Transform.filter_values(e),
          )
        end
      end

      rule(accPr: subtree(:accpr),
           e: sequence(:e)) do
        first_value  = Transform.filter_values(e)
        second_value = if accpr.flatten.compact.empty?
                         Math::Symbol.new("^")
                       else
                         first = accpr.find { |a| a.key?(:chr) }[:chr]
                         Transform.text_classes(first)
                       end
        Math::Function::Overset.new(
          first_value,
          second_value,
        )
      end

      rule(rPr: sequence(:rpr),
           lastRenderedPageBreak: sequence(:lastRenderedPageBreak),
           t: sequence(:t)) do
        Transform.text_classes(t)
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
          unary_class.new(Transform.filter_values(e))
        else
          Math::Formula.new(fName + e)
        end
      end

      rule(sSupPr: subtree(:sSuppr),
           e: subtree(:e),
           sup: subtree(:sup)) do
        Math::Function::Power.new(
          Transform.filter_values(e),
          Transform.filter_values(sup),
        )
      end

      rule(sSubPr: subtree(:sSuppr),
           e: subtree(:e),
           sub: subtree(:sub)) do
        Math::Function::Base.new(
          Transform.filter_values(e),
          Transform.filter_values(sub),
        )
      end

      rule(radPr: subtree(:radpr),
           deg: sequence(:deg),
           e: sequence(:e)) do
        if deg.empty?
          Math::Function::Sqrt.new(
            Transform.filter_values(e),
          )
        else
          Math::Function::Root.new(
            Transform.filter_values(deg),
            Transform.filter_values(e),
          )
        end
      end

      rule(sPrePr: subtree(:sPrepr),
           sub: sequence(:sub),
           sup: sequence(:sup),
           e: sequence(:e)) do
        Math::Function::Multiscript.new(
          Transform.filter_values(e),
          Transform.filter_values(sub),
          Transform.filter_values(sup),
        )
      end

      rule(sSubSupPr: subtree(:sSubSuppr),
           e: subtree(:e),
           sub: subtree(:sub),
           sup: subtree(:sup)) do
        Math::Function::PowerBase.new(
          Transform.filter_values(e),
          Transform.filter_values(sub),
          Transform.filter_values(sup),
        )
      end

      rule(naryPr: subtree(:narypr),
           sub: sequence(:sub),
           sup: sequence(:sup),
           e: sequence(:e)) do
        nary   = narypr&.flatten&.compact
        values = nary.find { |a| a.is_a?(Hash) }
        fonts  = Math::Symbol.new(values ? nary.delete(values)[:chr] : "∫")
        limloc = Transform.filter_values(nary)
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
                            Transform.filter_values(sub),
                            Transform.filter_values(sup),
                          )
                        end
        Transform.parse_nary_tag(first_formula, e)
      end

      class << self
        def filter_values(value)
          compact_value = value.flatten.compact
          if compact_value.length > 1
            Math::Formula.new(compact_value)
          else
            compact_value.first
          end
        end

        def text_classes(text)
          text = filter_values(text) unless text.is_a?(String)
          if text.scan(/[[:digit:]]/).length == text.length
            Math::Number.new(text)
          elsif text.match?(/[a-zA-Z]/)
            Math::Function::Text.new(text)
          else
            Math::Symbol.new(text)
          end
        end

        def parse_nary_tag(first_value, second_value)
          Math::Formula.new(
            [first_value, Math::Formula.new(second_value)],
          )
        end
      end
    end
  end
end
