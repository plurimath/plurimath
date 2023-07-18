# frozen_string_literal: true

module Plurimath
  class Mathml
    class Transform < Parslet::Transform
      rule(mi: simple(:mi))         { mi }
      rule(mo: simple(:mo))         { mo }
      rule(mo: sequence(:mo))       { Utility.mathml_unary_classes(mo) }
      rule(mtd: sequence(:mtd))     { Math::Function::Td.new(mtd) }
      rule(mtr: sequence(:mtr))     { Math::Function::Tr.new(mtr) }
      rule(none: sequence(:none))   { nil }
      rule(notation: simple(:att))  { Math::Function::Menclose.new(att) }
      rule(mtable: simple(:table))  { table }
      rule(msqrt: sequence(:sqrt))  { Math::Function::Sqrt.new(sqrt.first) }
      rule(mstyle: simple(:mstyle)) { mstyle }
      rule(msline: sequence(:line)) { Math::Function::Msline.new }
      rule(value: sequence(:value)) { Utility.filter_values(value) }

      rule(mspace: sequence(:space))    { nil }
      rule(mstyle: sequence(:mstyle))   { Utility.filter_values(mstyle) }
      rule(mfenced: simple(:mfenced))   { mfenced }
      rule(mtable: sequence(:mtable))   { Math::Function::Table.new(mtable) }
      rule(mscarry: sequence(:scarry))  { nil }
      rule(menclose: simple(:enclose))  { enclose }
      rule(mlabeledtr: sequence(:mtr))  { Math::Function::Tr.new(mtr) }
      rule(mpadded: sequence(:padded))  { Utility.filter_values(padded) }
      rule(malignmark: sequence(:mark)) { nil }
      rule(maligngroup: sequence(:att)) { nil }
      rule(mprescripts: sequence(:att)) { "mprescripts" }
      rule(columnlines: simple(:lines)) { lines }

      rule(math: subtree(:math)) do
        Utility.filter_values(
          math.flatten.compact,
        )
      end

      rule(mphantom: sequence(:phantom)) do
        Math::Function::Phantom.new(phantom)
      end

      rule(mn: sequence(:mn)) do
        Math::Number.new(
          Utility.string_to_html_entity(
            mn.join,
          ),
        )
      end

      rule(mathvariant: simple(:variant)) do
        Utility::FONT_STYLES[variant.to_sym]&.new(nil, variant)
      end

      rule(mi: sequence(:mi)) do
        mi.any?(String) ? Utility.mathml_unary_classes(mi) : mi
      end

      rule(open: simple(:lparen)) do
        Math::Function::Fenced.new(Math::Symbol.new(lparen))
      end

      rule(msgroup: sequence(:group)) do
        if group.any?(String)
          group.each_with_index do |object, ind|
            group[ind] = Utility.text_classes(object) if object.is_a?(String)
          end
        end
        Math::Function::Msgroup.new(group.flatten.compact)
      end

      rule(mlongdiv: sequence(:long)) do
        Math::Function::Longdiv.new(long.flatten.compact)
      end

      rule(menclose: sequence(:close)) do
        Math::Function::Menclose.new(
          nil,
          Utility.filter_values(close),
        )
      end

      rule(mroot: sequence(:mroot)) do
        Math::Function::Root.new(
          mroot[1],
          mroot[0],
        )
      end

      rule(merror: sequence(:merror)) do
        Math::Function::Merror.new(
          merror[0],
          merror[1],
        )
      end

      rule(mfrac: sequence(:mfrac)) do
        Math::Function::Frac.new(
          mfrac[0],
          mfrac[1],
        )
      end

      rule(mfraction: sequence(:mfrac)) do
        Math::Function::Frac.new(
          mfrac[0],
          mfrac[1],
        )
      end

      rule(msub: sequence(:msub)) do
        Math::Function::Base.new(
          msub[0],
          msub[1],
        )
      end

      rule(msub: subtree(:msub)) do
        Math::Function::Base.new(
          Utility.filter_values(msub[0]),
          Utility.filter_values(msub[1]),
        )
      end

      rule(msup: subtree(:msup)) do
        Math::Function::Power.new(
          Utility.filter_values(msup[0]),
          Utility.filter_values(msup[1]),
        )
      end

      rule(msup: sequence(:msup)) do
        Math::Function::Power.new(
          msup[0],
          msup[1],
        )
      end

      rule(msubsup: sequence(:msubsup)) do
        Math::Function::PowerBase.new(
          msubsup[0],
          msubsup[1],
          msubsup[2],
        )
      end

      rule(munderover: sequence(:function)) do
        binary_function = Plurimath::Math::Function::BinaryFunction
        ternary_function = Plurimath::Math::Function::TernaryFunction
        base_class = function[0]&.value&.first if function[0].is_a?(Math::Formula)
        if base_class&.class&.ancestors&.include?(binary_function)
          base_class.parameter_one = function[1]
          base_class.parameter_two = function[2]
          base_class
        elsif base_class&.class&.ancestors&.include?(ternary_function)
          base_class.parameter_one = function[1]
          base_class.parameter_two = function[2]
          base_class.parameter_three = function[3]
          base_class
        else
          Math::Function::Underover.new(
            function[0],
            function[1],
            function[2],
          )
        end
      end

      rule(mrow: subtree(:mrow)) do
        if mrow.any?(String)
          mrow.each_with_index do |object, ind|
            mrow[ind] = Utility.mathml_unary_classes([object]) if object.is_a?(String)
          end
        end
        Math::Formula.new(mrow.flatten.compact)
      end

      rule(msrow: sequence(:msrow)) do
        Math::Formula.new(msrow.flatten.compact)
      end

      rule(mstack: sequence(:stack)) do
        Math::Function::Stackrel.new(
          Utility.filter_values(stack),
        )
      end

      rule(mover: sequence(:mover)) do
        if ["ubrace", "obrace"].any?(mover.last.class_name)
          mover.last.parameter_one = mover.shift if mover.length > 1
          mover.last
        else
          Math::Function::Overset.new(
            mover[1],
            mover[0],
          )
        end
      end

      rule(munder: sequence(:munder)) do
        if munder.any?(String)
          munder.each_with_index do |object, ind|
            munder[ind] = Utility.mathml_unary_classes([object]) if object.is_a?(String)
          end
        end
        if ["ubrace", "obrace"].any?(munder.last.class_name)
          munder.last.parameter_one = munder.shift if munder.length > 1
          munder.last
        else
          Math::Function::Underset.new(
            munder[1],
            munder[0],
          )
        end
      end

      rule(mscarries: sequence(:scarries)) do
        Math::Function::Scarries.new(
          Utility.filter_values(scarries),
        )
      end

      rule(mtext: subtree(:mtext)) do
        entities = HTMLEntities.new
        symbols  = Constants::UNICODE_SYMBOLS.transform_keys(&:to_s)
        text     = entities.encode(mtext.flatten.join, :hexadecimal)
        symbols.each do |code, string|
          text.gsub!(code.downcase, "unicode[:#{string}]")
        end
        Math::Function::Text.new(text)
      end

      rule(ms: sequence(:ms)) do
        entities = HTMLEntities.new
        symbols  = Constants::UNICODE_SYMBOLS.transform_keys(&:to_s)
        text     = entities.encode(ms.first, :hexadecimal)
        symbols.each do |code, string|
          text.gsub!(code.downcase, "unicode[:#{string}]")
        end
        Math::Function::Text.new(text)
      end

      rule(mfenced: sequence(:fenced)) do
        Math::Function::Fenced.new(
          Math::Symbol.new("("),
          fenced.compact,
          Math::Symbol.new(")"),
        )
      end

      rule(mmultiscripts: subtree(:script)) do
        multi = Utility.multiscript(script.compact)
        prescripts = multi[1]
        Math::Function::Multiscript.new(
          multi[0],
          (prescripts[0] if prescripts),
          (prescripts[1] if prescripts),
        )
      end

      rule(mathcolor: simple(:color)) do
        Math::Function::Color.new(
          Math::Function::Text.new(color),
        )
      end

      rule(open: simple(:lparen),
           close: simple(:rparen)) do
        Math::Function::Fenced.new(
          Math::Symbol.new(lparen),
          nil,
          Math::Symbol.new(rparen),
        )
      end

      rule(mathcolor: simple(:color),
           mathvariant: simple(:variant)) do
        variant_class = Utility::FONT_STYLES[variant.to_sym]
        if variant_class
          Math::Function::Color.new(
            Math::Function::Text.new(
              color,
            ),
            variant_class.new(
              nil,
              variant,
            ),
          )
        else
          Math::Function::Color.new(
            Math::Function::Text.new(
              color,
            ),
          )
        end
      end

      rule(attributes: simple(:attrs),
           value: subtree(:value)) do
        Utility.join_attr_value(attrs, value&.flatten&.compact)
      end

      rule(semantics: subtree(:value)) do
        Math::Function::Semantics.new(
          value.shift,
          value,
        )
      end

      rule(attributes: subtree(:attrs),
           value: sequence(:value)) do
        Utility.join_attr_value(
          attrs.is_a?(Hash) ? nil : attrs,
          value&.flatten&.compact,
        )
      end
    end
  end
end
