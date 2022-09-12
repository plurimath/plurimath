# frozen_string_literal: true

require "parslet"
module Plurimath
  class Omml
    class Transform < Parslet::Transform
      rule(r: simple(:r)) { r }
      rule(f: simple(:f)) { f }
      rule(d: simple(:d)) { Math::Function::Fenced.new(nil, [d], nil) }
      rule(val: simple(:val)) { val }
      rule(box: simple(:box)) { box }
      rule(rPr: simple(:rpr)) { nil }
      rule(rad: simple(:rad)) { rad }
      rule(sSub: simple(:sub)) { sub }
      rule(eqArr: simple(:arr)) { arr }
      rule(nary: simple(:nary)) { nary }
      rule(sSup: simple(:sSup)) { sSup }
      rule(sPre: simple(:sPre)) { sPre }
      rule(ctrlPr: simple(:ctrlPr)) { nil }
      rule(argSz: sequence(:argsz)) { nil }
      rule(rFonts: sequence(:fonts)) { nil }
      rule(sSubSup: simple(:sSubSup)) { sSubSup }
      rule(oMathPara: subtree(:omath)) { omath.drop(1) }
      rule(rPr: simple(:rpr), i: simple(:i)) { nil }
      rule(dPr: simple(:dpr), e: simple(:e)) { e }
      rule(dPr: simple(:dpr), e: sequence(:e)) { e }
      rule(boxPr: simple(:boxpr), e: simple(:e)) { e }
      rule(argPr: simple(:argPr), f: simple(:f)) { f }
      rule(rFonts: sequence(:fonts), i: simple(:i)) { nil }
      rule(type: sequence(:type), ctrlPr: simple(:ctrl)) { nil }
      rule(ascii: simple(:ascii), hAnsi: simple(:hansi)) { nil }
      rule(diff: sequence(:diff), ctrlPr: simple(:ctrl)) { nil }
      rule(limLoc: sequence(:limloc), ctrlPr: simple(:ctrl)) { limloc }
      rule(degHide: sequence(:degHide), ctrlPr: simple(:ctrl)) { nil }

      rule(oMath: subtree(:omath)) do
        omath.is_a?(Array) ? omath.drop(1) : omath
      end

      rule(d: sequence(:d)) do
        open_paren = d.shift if d.first.class_name == "symbol"
        close_paren = d.pop if d.last.class_name == "symbol"
        Math::Function::Fenced.new(
          open_paren,
          d,
          close_paren,
        )
      end

      rule(dPr: sequence(:dpr),
           e: simple(:e)) do
        [
          dpr[0],
          e,
          dpr[1],
        ]
      end

      rule(sSub: sequence(:sub), r: simple(:r)) do
        [
          Math::Formula.new(
            sub.insert(1, r),
          ),
        ]
      end

      rule(rPr: simple(:rpr), t: subtree(:t)) do
        Math::Function::Text.new(t.last)
      end

      rule(r: simple(:r), d: simple(:d)) do
        Math::Formula.new(
          [
            r,
            d,
          ],
        )
      end

      rule(eqArrPr: simple(:aqArrPr), e: sequence(:e)) do
        table_value = []
        e.each do |value|
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

      rule(rPr: simple(:rpr),
           t: simple(:text)) do
        if text.scan(/[[:digit:]]/).length == text.length
          Math::Number.new(text)
        elsif text.match?(/[[:alpha:]]/)
          Math::Function::Text.new(text)
        else
          Math::Symbol.new(text)
        end
      end

      rule(radPr: simple(:rad),
           deg: simple(:deg),
           e: simple(:e)) do
        if deg.nil?
          Math::Function::Sqrt.new(e)
        else
          Math::Function::Root.new(deg, e)
        end
      end

      rule(fPr: simple(:fpr), num: simple(:num), den: simple(:den)) do
        Math::Function::Frac.new(num, den)
      end

      rule(sSupPr: simple(:sSuppr), e: simple(:e), sup: simple(:power)) do
        Math::Function::Power.new(e, power)
      end

      rule(sSubPr: simple(:sSubpr), e: simple(:e), sub: simple(:base)) do
        Math::Function::Base.new(e, base)
      end

      rule(chr: sequence(:chr),
           ctrlPr: simple(:ctrl)) do
        [nil] + chr
      end

      rule(chr: sequence(:chr),
           limLoc: sequence(:limloc),
           ctrlPr: simple(:ctrl)) do
        limloc + chr
      end

      rule(begChr: sequence(:begChr),
           endChr: sequence(:endChr),
           ctrlPr: simple(:ctrl)) do
        [
          Math::Symbol.new(begChr.first),
          Math::Symbol.new(endChr.first),
        ]
      end

      rule(chr: sequence(:chr),
           supHide: sequence(:supHide),
           ctrlPr: simple(:ctrl)) do
        [nil] + chr
      end

      rule(chr: sequence(:chr),
           limLoc: sequence(:limloc),
           supHide: sequence(:sup),
           ctrlPr: simple(:ctrl)) do
        limloc + chr
      end

      rule(limLoc: sequence(:limloc),
           subHide: sequence(:sub),
           supHide: sequence(:sup),
           ctrlPr: simple(:ctrl)) do
        limloc
      end

      rule(chr: sequence(:chr),
           limLoc: sequence(:limloc),
           subHide: sequence(:sub),
           supHide: sequence(:sup),
           ctrlPr: simple(:ctrl)) do
        limloc + chr
      end

      rule(naryPr: sequence(:naryPr),
           sub: simple(:base),
           sup: simple(:power),
           e: simple(:e)) do
        fonts = Plurimath::Math::Symbol.new(naryPr[1] || "∫")
        first_value = if base.nil? && power.nil?
                        fonts
                      elsif naryPr.first == "undOvr"
                        Math::Function::Underover.new(fonts, base, power)
                      else
                        Math::Function::PowerBase.new(fonts, base, power)
                      end
        Math::Formula.new(
          [
            first_value,
            Math::Formula.new(
              [
                e,
              ],
            ),
          ],
        )
      end

      rule(sSubSupPr: simple(:sSubSuppr),
           e: simple(:e),
           sub: simple(:base),
           sup: simple(:power)) do
        Math::Function::PowerBase.new(e, base, power)
      end

      rule(sPrePr: simple(:sPrePr),
           e: simple(:e),
           sub: simple(:base),
           sup: simple(:power)) do
        Math::Function::Multiscript.new(e, base, power)
      end
    end
  end
end
