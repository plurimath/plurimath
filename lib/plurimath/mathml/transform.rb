# frozen_string_literal: true

module Plurimath
  class Mathml
    class Transform < Parslet::Transform
      rule(tag: simple(:tag))       { tag }
      rule(tag: sequence(:tag))     { tag }
      rule(text: simple(:text))     { Plurimath::Math::Symbol.new(text.to_s) }
      rule(class: simple(:string))  { Transform.get_class(string).new }
      rule(number: simple(:number)) { Plurimath::Math::Number.new(number.to_s) }
      rule(tag: sequence(:tag), sequence: simple(:sequence)) { tag + [sequence] }
      rule(tag: simple(:tag), sequence: sequence(:sequence)) { [tag] + sequence }
      rule(tag: sequence(:tag), sequence: sequence(:sequence)) { tag + sequence }

      rule(quoted_text: simple(:quoted_text)) do
        text = quoted_text.to_s
        Constants::UNICODE_SYMBOLS.each do |code, string|
          text.gsub!(code.to_s, string)
        end
        Plurimath::Math::Function::Text.new(text)
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
        Plurimath::Math::Formula.new(tag + [sequence])
      end

      rule(
        tag: simple(:tag),
        sequence: simple(:sequence),
        iteration: simple(:iteration),
      ) do
        [tag, sequence]
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
          Transform.get_class(decoded_symbol).new
        else
          Plurimath::Math::Symbol.new(decoded_symbol)
        end
      end

      rule(name: simple(:name), value: simple(:value)) do
        if ["open", "close", "mathcolor"].include?(name.to_s)
          Plurimath::Math::Symbol.new(value.to_s)
        end
      end

      rule(
        tag: simple(:tag),
        sequence: sequence(:sequence),
        iteration: simple(:iteration),
      ) do
        tag_str = tag.to_s.split("::").last.downcase.to_sym
        if Constants::BINARY_CLASSES.include?(tag_str)
          tag.new(sequence.first, sequence.last)
        else
          new_arr = sequence.compact
          new_arr = [tag] + new_arr unless tag.nil?
          new_arr << iteration unless iteration.to_s.empty?
          new_arr
        end
      end

      rule(
        open: simple(:open_tag),
        attributes: sequence(:attributes),
        iteration: sequence(:iteration),
        close: simple(:close_tag),
      ) do
        Transform.raise_error!(open_tag, close_tag) unless open_tag == close_tag
        if open_tag == "mrow"
          Plurimath::Math::Formula.new(iteration)
        elsif open_tag == "munder"
          if Transform.get_class("obrace") == iteration.last.class
            iteration.last.parameter_one = iteration.first
            iteration.last
          else
            Plurimath::Math::Function::Underset.new(iteration[1], iteration[0])
          end
        elsif open_tag == "munderover"
          Plurimath::Math::Function::Underover.new(iteration[0], iteration[1], iteration[2])
        elsif open_tag == "mover"
          if Transform.get_class("ubrace") == iteration.last.class
            iteration.last.parameter_one = iteration.first
            iteration.last
          else
            Plurimath::Math::Function::Overset.new(iteration[1], iteration[0])
          end
        elsif ["msub", "msup"].include?(open_tag.to_s)
          symbol = Plurimath::Math::Symbol.new(open_tag == "msub" ? "_" : "^")
          iteration.insert(1, symbol)
        elsif open_tag == "msubsup"
          Plurimath::Math::Function::Subsup.new(iteration[0], iteration[1], iteration[2])
        elsif open_tag == "mfrac"
          Plurimath::Math::Function::Frac.new(iteration.first, iteration.last)
        elsif open_tag == "msqrt"
          Plurimath::Math::Function::Sqrt.new(iteration.first)
        elsif open_tag == "mroot"
          Plurimath::Math::Function::Root.new(iteration[0], iteration[1])
        elsif open_tag == "mfenced"
          iteration.insert(0, attributes[0])
          iteration << attributes[1]
        elsif open_tag == "mstyle" && !attributes.compact.empty?
          Plurimath::Math::Function::Color.new(attributes[0], iteration[0])
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
        Transform.raise_error!(open_tag, close_tag) unless open_tag == close_tag
        if iteration.to_s.include?("Function")
          iteration
        else
          [iteration.to_s.empty? ? nil : iteration]
        end
      end

      def self.get_class(text)
        Object.const_get("Plurimath::Math::Function::#{text.to_s.capitalize}")
      end

      def self.raise_error!(open_tag, close_tag)
        message = "Please check your input."\
                  " Opening tag is \"#{open_tag}\""\
                  "and closing tag is \"#{close_tag}\""
        raise Plurimath::Math::Error.new(message)
      end
    end
  end
end
