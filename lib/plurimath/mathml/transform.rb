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
      rule(mspace: simple(:space))  { nil }
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
        Math::Function::Phantom.new(
          Utility.filter_values(phantom),
        )
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
          Utility.filter_values(merror),
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

      rule(msubsup: sequence(:function)) do
        base = function[0].is_a?(Math::Formula) ? function[0].value : function
        base_object = base.first
        if base_object.is_a?(Math::Function::BinaryFunction) && !base_object.any_value_exist?
          base_object.parameter_one = function[1]
          base_object.parameter_two = function[2]
          base_object
        elsif base_object.is_a?(Math::Function::TernaryFunction) && !base_object.any_value_exist?
          base_object.parameter_one = function[1]
          base_object.parameter_two = function[2]
          base_object.parameter_three = function[3]
          base_object
        else
          Math::Function::PowerBase.new(
            function[0],
            function[1],
            function[2],
          )
        end
      end

      rule(munderover: sequence(:function)) do
        base = function[0].is_a?(Math::Formula) ? function[0].value : function
        base_object = base.first
        if base_object.is_a?(Math::Function::BinaryFunction) && !base_object.any_value_exist?
          base_object.parameter_one = function[1]
          base_object.parameter_two = function[2]
          base_object
        elsif base_object.is_a?(Math::Function::TernaryFunction) && !base_object.any_value_exist?
          base_object.parameter_one = function[1]
          base_object.parameter_two = function[2]
          base_object.parameter_three = function[3]
          base_object
        else
          Math::Function::Underover.new(
            function[0],
            function[1],
            function[2],
          )
        end
      end

      rule(mrow: subtree(:mrow)) do
        flatten_mrow = Utility.populate_function_classes(mrow)
        Utility.fenceable_classes(flatten_mrow)
        if flatten_mrow.length == 1
          flatten_mrow.first
        else
          Math::Formula.new(
            flatten_mrow,
            Utility.mrow_left_right(flatten_mrow),
          )
        end
      end

      rule(msrow: sequence(:msrow)) do
        Math::Formula.new(msrow.flatten.compact)
      end

      rule(mstack: sequence(:stack)) do
        Math::Function::Stackrel.new(
          Utility.filter_values(stack),
        )
      end

      rule(mover: subtree(:mover)) do
        if mover&.length == 1
          base_object = mover.first
          base_object.class_name == "underline" ? base_object.swap_class : base_object
        elsif Constants::CLASSES.any?(mover&.last&.class_name)
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
            next unless object.is_a?(String)

            munder[ind] = Utility.mathml_unary_classes([object])
          end
        end
        if munder.length == 1
          munder.first.class_name == "bar" ? munder.first.swap_class : munder.last
        elsif ["ubrace", "obrace", "underline"].any?(munder.last.class_name)
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
          text = text.gsub(code.downcase, "unicode[:#{string}]")
        end
        Math::Function::Text.new(text)
      end

      rule(ms: sequence(:ms)) do
        entities = HTMLEntities.new
        symbols  = Constants::UNICODE_SYMBOLS.transform_keys(&:to_s)
        text     = entities.encode(ms.first, :hexadecimal)
        symbols.each do |code, string|
          text = text.gsub(code.downcase, "unicode[:#{string}]")
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

      rule(semantics: subtree(:value)) do
        Math::Function::Semantics.new(
          value.shift,
          value,
        )
      end

      rule(attributes: simple(:attrs),
           value: subtree(:value)) do
        Utility.join_attr_value(attrs, value&.flatten&.compact)
      end

      rule(attributes: subtree(:attrs),
           value: sequence(:value)) do
        approved = if attrs.is_a?(Hash)
                     supported = %w[accentunder accent linebreak]
                     if attrs.keys.any? { |k| supported.include?(k.to_s) }
                       unicode_only = true if attrs.key?(:linebreak)
                       attrs
                     end
                   else
                     attrs
                   end
        Utility.join_attr_value(
          approved,
          value&.flatten&.compact,
          unicode_only: unicode_only,
        )
      end
    end
  end
end
