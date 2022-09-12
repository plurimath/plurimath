# frozen_string_literal: true

module Plurimath
  class Mathml
    class Transform < Parslet::Transform
      rule(tag: simple(:tag))       { tag }
      rule(tag: sequence(:tag))     { tag }
      rule(text: simple(:text))     { Math::Symbol.new(text) }
      rule(class: simple(:string))  { Utility.get_class(string).new }
      rule(number: simple(:number)) { Math::Number.new(number) }

      rule(tag: sequence(:tag), sequence: simple(:sequence)) do
        tag + [sequence]
      end

      rule(tag: simple(:tag), sequence: sequence(:sequence)) do
        [tag] + sequence
      end

      rule(tag: sequence(:tag), sequence: sequence(:sequence)) do
        tag + sequence
      end

      rule(quoted_text: simple(:quoted_text)) do
        text = quoted_text
        symbols = Constants::UNICODE_SYMBOLS.transform_keys(&:to_s)
        symbols.each do |code, string|
          text.gsub!(code, "unicode[:#{string}]")
        end
        Math::Function::Text.new(text)
      end

      rule(
        tag: sequence(:tag),
        sequence: sequence(:sequence),
        iteration: simple(:iteration),
      ) do
        new_arr = []
        new_arr = new_arr + tag unless tag.compact.empty?
        new_arr = new_arr + sequence unless sequence.compact.empty?
        new_arr << iteration unless iteration.to_s.empty?
        new_arr
      end

      rule(
        tag: sequence(:tag),
        sequence: simple(:sequence),
        iteration: simple(:iteration),
      ) do
        Math::Formula.new(tag + [sequence, iteration])
      end

      rule(
        tag: simple(:tag),
        sequence: simple(:sequence),
        iteration: simple(:iteration),
      ) do
        iteration.size.zero? ? [tag, sequence] : [tag, sequence, iteration]
      end

      rule(tag: sequence(:tag), iteration: simple(:iteration)) do
        new_arr = []
        new_arr = tag unless tag.compact.empty?
        new_arr << iteration unless iteration.to_s.empty?
        new_arr
      end

      rule(tag: simple(:tag), sequence: simple(:sequence)) do
        new_arr = []
        new_arr << tag unless tag.nil?
        new_arr << sequence unless sequence.nil?
        new_arr
      end

      rule(tag: simple(:tag), iteration: simple(:iteration)) do
        new_arr = []
        new_arr << tag unless tag.to_s.empty?
        new_arr << iteration unless iteration.to_s.empty?
        new_arr
      end

      rule(symbol: simple(:symbol)) do
        decoded_symbol = Constants::UNICODE_SYMBOLS[symbol.to_sym]
        if Constants::CLASSES.include?(decoded_symbol)
          [Utility.get_class(decoded_symbol).new]
        elsif decoded_symbol.nil? && Constants::SYMBOLS[symbol.to_sym]
          Math::Symbol.new(Constants::SYMBOLS[symbol.to_sym])
        else
          Math::Symbol.new(decoded_symbol)
        end
      end

      rule(name: simple(:name), value: simple(:value)) do
        if ["open", "close"].include?(name)
          Math::Symbol.new(value)
        elsif name == "mathcolor"
          Math::Function::Color.new(value)
        elsif name == "mathvariant"
          value
        end
      end

      rule(
        tag: simple(:tag),
        sequence: sequence(:sequence),
        iteration: simple(:iteration),
      ) do
        new_arr = sequence.compact
        new_arr = [tag] + new_arr unless tag.nil?
        new_arr << iteration unless iteration.to_s.empty?
        new_arr
      end

      rule(
        open: simple(:open_tag),
        attributes: sequence(:attributes),
        iteration: sequence(:iteration),
        close: simple(:close_tag),
      ) do
        Utility.raise_error!(open_tag, close_tag) unless open_tag == close_tag

        if open_tag == "mrow"
          Math::Formula.new(iteration)
        elsif open_tag == "munder"
          if iteration.last.class_name == "obrace"
            iteration.last.parameter_one = iteration.first
            iteration.last
          else
            Math::Function::Underset.new(iteration[1], iteration[0])
          end
        elsif open_tag == "munderover"
          Utility.get_class(open_tag.delete_prefix("m")).new(
            iteration[0],
            iteration[1],
            iteration[2],
          )
        elsif open_tag == "mover"
          if iteration.last.class_name == "ubrace"
            iteration.last.parameter_one = iteration.first
            iteration.last
          else
            Math::Function::Overset.new(iteration[1], iteration[0])
          end
        elsif ["msub", "msup"].include?(open_tag)
          tag = (open_tag == "msup" ? "power" : "base")
          Utility.get_class(tag).new(iteration[0], iteration[1])
        elsif open_tag == "msubsup"
          Math::Function::PowerBase.new(iteration[0],
                                        iteration[1],
                                        iteration[2])
        elsif open_tag == "mfrac"
          Math::Function::Frac.new(iteration.first, iteration.last)
        elsif open_tag == "msqrt"
          Math::Function::Sqrt.new(iteration.first)
        elsif open_tag == "mroot"
          Math::Function::Root.new(iteration[0], iteration[1])
        elsif open_tag == "mfenced"
          Math::Function::Fenced.new(
            attributes[0],
            iteration,
            attributes[1],
          )
        elsif ["mtr", "mtd", "mtable"].include?(open_tag)
          tag = open_tag.delete_prefix("m")
          Utility.get_class(tag).new(iteration)
        elsif attributes.first.is_a?(Math::Function::Color)
          attributes.first.parameter_two = iteration.first
          attributes.first
        elsif open_tag == "mstyle" && !attributes.compact.empty?
          font_type = attributes.compact.last
          if Utility::FONT_STYLES.key?(font_type.to_sym)
            Utility::FONT_STYLES[font_type.to_sym].new(
              iteration.last,
              font_type,
            )
          else
            Math::Function::FontStyle.new(iteration.last, font_type)
          end
        else
          iteration
        end
      end

      rule(
        open: simple(:open_tag),
        attributes: sequence(:attributes),
        iteration: simple(:iteration),
        close: simple(:close_tag),
      ) do
        Utility.raise_error!(open_tag, close_tag) unless open_tag == close_tag

        if iteration.to_s.include?("Function")
          iteration
        else
          [iteration.to_s.empty? ? nil : iteration]
        end
      end
    end
  end
end
