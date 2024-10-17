# frozen_string_literal: true

module Plurimath
  class Mathml
    module Utility
      self.attr_accessor :temp_mathml_order

      def element_order=(value)
        self.temp_mathml_order = validated_order(value)
      end

      def mi_value; end

      def mo_value; end

      def mn_value; end

      def ms_value; end

      def mtd_value; end

      def mtr_value; end

      def msub_value; end

      def msup_value; end

      def mrow_value; end

      def mover_value; end

      def mtext_value; end

      def mfrac_value; end

      def msqrt_value; end

      def mtable_value; end

      def mstyle_value; end

      def munder_value; end

      def msubsup_value; end

      def mfenced_value; end

      def munderover_value; end

      def table_row_expression; end

      def table_row_expression=(value)
        return if value.nil? || value.empty?

        raise_development_error(value)
      end

      def table_cell_expression; end

      def table_cell_expression=(value)
        return if value.nil? || value.empty?

        raise_development_error(value)
      end

      def mi; end

      def mo; end

      def mstyle; end

      def mrow; end

      def mn; end

      def ms; end

      def mtext; end

      def mfrac; end

      def msqrt; end

      def msub; end

      def msubsup; end

      def munderover; end

      def munder; end

      def mover; end

      def msup; end

      def mtable; end

      def mtr; end

      def mtd; end

      def malignmark; end

      def malignmark=(value); end

      def mathcolor; end

      def mathcolor=(value); end

      def mathbackground; end

      def mathbackground=(value); end

      def mathvariant; end

      def mathvariant=(value); end

      def mathsize; end

      def mathsize=(value); end

      def dir; end

      def dir=(value); end

      def fontfamily; end

      def fontfamily=(value); end

      def fontweight; end

      def fontweight=(value); end

      def fontstyle; end

      def fontstyle=(value); end

      def fontsize; end

      def fontsize=(value); end

      def color; end

      def color=(value); end

      def mathbackgroundcolor; end

      def mathbackgroundcolor=(value); end

      def background; end

      def background=(value); end

      def scriptlevel; end

      def scriptlevel=(value); end

      def displaystyle; end

      def displaystyle=(value); end

      def scriptsizemultiplier; end

      def scriptsizemultiplier=(value); end

      def scriptminsize; end

      def scriptminsize=(value); end

      def infixlinebreakstyle; end

      def infixlinebreakstyle=(value); end

      def decimalpoint; end

      def decimalpoint=(value); end

      def accent; end

      def accent=(value); end

      def accentunder; end

      def accentunder=(value); end

      def align; end

      def align=(value); end

      def alignmentscope; end

      def alignmentscope=(value); end

      def bevelled; end

      def bevelled=(value); end

      def charalign; end

      def charalign=(value); end

      def charspacing; end

      def charspacing=(value); end

      def close; end

      def close=(value); end

      def columnalign; end

      def columnalign=(value); end

      def columnlines; end

      def columnlines=(value); end

      def columnspacing; end

      def columnspacing=(value); end

      def columnspan; end

      def columnspan=(value); end

      def columnwidth; end

      def columnwidth=(value); end

      def crossout; end

      def crossout=(value); end

      def denomalign; end

      def denomalign=(value); end

      def depth; end

      def depth=(value); end

      def edge; end

      def edge=(value); end

      def equalcolumns; end

      def equalcolumns=(value); end

      def equalrows; end

      def equalrows=(value); end

      def fence; end

      def fence=(value); end

      def form; end

      def form=(value); end

      def frame; end

      def frame=(value); end

      def framespacing; end

      def framespacing=(value); end

      def groupalign; end

      def groupalign=(value); end

      def height; end

      def height=(value); end

      def indentalign; end

      def indentalign=(value); end

      def indentalignfirst; end

      def indentalignfirst=(value); end

      def indentalignlast; end

      def indentalignlast=(value); end

      def indentshift; end

      def indentshift=(value); end

      def indentshiftfirst; end

      def indentshiftfirst=(value); end

      def indentshiftlast; end

      def indentshiftlast=(value); end

      def indenttarget; end

      def indenttarget=(value); end

      def largeop; end

      def largeop=(value); end

      def leftoverhang; end

      def leftoverhang=(value); end

      def length; end

      def length=(value); end

      def linebreak; end

      def linebreak=(value); end

      def linebreakmultchar; end

      def linebreakmultchar=(value); end

      def linebreakstyle; end

      def linebreakstyle=(value); end

      def lineleading; end

      def lineleading=(value); end

      def linethickness; end

      def linethickness=(value); end

      def location; end

      def location=(value); end

      def longdivstyle; end

      def longdivstyle=(value); end

      def lquote; end

      def lquote=(value); end

      def lspace; end

      def lspace=(value); end

      def maxsize; end

      def maxsize=(value); end

      def minlabelspacing; end

      def minlabelspacing=(value); end

      def minsize; end

      def minsize=(value); end

      def movablelimits; end

      def movablelimits=(value); end

      def mslinethickness; end

      def mslinethickness=(value); end

      def notation; end

      def notation=(value); end

      def numalign; end

      def numalign=(value); end

      def open; end

      def open=(value); end

      def position; end

      def position=(value); end

      def rightoverhang; end

      def rightoverhang=(value); end

      def rowalign; end

      def rowalign=(value); end

      def rowlines; end

      def rowlines=(value); end

      def rowspacing; end

      def rowspacing=(value); end

      def rowspan; end

      def rowspan=(value); end

      def rquote; end

      def rquote=(value); end

      def rspace; end

      def rspace=(value); end

      def selection; end

      def selection=(value); end

      def separator; end

      def separator=(value); end

      def separators; end

      def separators=(value); end

      def shift; end

      def shift=(value); end

      def side; end

      def side=(value); end

      def stackalign; end

      def stackalign=(value); end

      def stretchy; end

      def stretchy=(value); end

      def subscriptshift; end

      def subscriptshift=(value); end

      def superscriptshift; end

      def superscriptshift=(value); end

      def symmetric; end

      def symmetric=(value); end

      def valign; end

      def valign=(value); end

      def width; end

      def width=(value); end

      def veryverythinmathspace; end

      def veryverythinmathspace=(value); end

      def verythinmathspace; end

      def verythinmathspace=(value); end

      def thinmathspace; end

      def thinmathspace=(value); end

      def mediummathspace; end

      def mediummathspace=(value); end

      def thickmathspace; end

      def thickmathspace=(value); end

      def verythickmathspace; end

      def verythickmathspace=(value); end

      def veryverythickmathspace; end

      def veryverythickmathspace=(value); end

      def mi_value=(value)
        return if value.nil? || value.empty?

        self.temp_mathml_order = replace_order_with_value(
          self.temp_mathml_order,
          validate_symbols(value),
          "mi"
        )
      end

      def mo_value=(value)
        return if value.nil? || value.empty?

        self.temp_mathml_order = replace_order_with_value(
          self.temp_mathml_order,
          validate_symbols(value),
          "mo"
        )
      end

      def mn_value=(value)
        return if value.nil? || value.empty?

        self.temp_mathml_order = replace_order_with_value(
          self.temp_mathml_order,
          validate_symbols(value),
          "mn"
        )
      end

      def ms_value=(value)
        return if value.nil? || value.empty?

        self.temp_mathml_order = replace_order_with_value(
          self.temp_mathml_order,
          Array(value),
          "ms"
        )
      end

      def mtext_value=(value)
        return if value.nil? || value.empty?

        self.temp_mathml_order = replace_order_with_value(
          self.temp_mathml_order,
          Array(value),
          "mtext"
        )
      end

      def mrow_value=(value)
        return if value.nil? || value.empty?

        self.temp_mathml_order = replace_order_with_value(
          self.temp_mathml_order,
          value,
          "mrow"
        )
      end

      def mstyle_value=(value)
        return if value.nil? || value.empty?

        self.temp_mathml_order = replace_order_with_value(
          self.temp_mathml_order,
          Array(value),
          "mstyle"
        )
      end

      def mfrac_value=(value)
        return if value.nil? || value.empty?

        self.temp_mathml_order = replace_order_with_value(
          self.temp_mathml_order,
          Array(update_temp_mathml_values(value)),
          "mfrac"
        )
      end

      def munderover_value=(value)
        return if value.nil? || value.empty?

        self.temp_mathml_order = replace_order_with_value(
          self.temp_mathml_order,
          update_temp_mathml_values(value),
          "munderover"
        )
      end

      def msubsup_value=(value)
        return if value.nil? || value.empty?

        self.temp_mathml_order = replace_order_with_value(
          self.temp_mathml_order,
          update_temp_mathml_values(value),
          "msubsup"
        )
      end

      def munder_value=(value)
        return if value.nil? || value.empty?

        self.temp_mathml_order = replace_order_with_value(
          self.temp_mathml_order,
          Array(value),
          "munder"
        )
      end

      def mover_value=(value)
        return if value.nil? || value.empty?

        self.temp_mathml_order = replace_order_with_value(
          self.temp_mathml_order,
          Array(value),
          "mover"
        )
      end

      def msup_value=(value)
        return if value.nil? || value.empty?

        self.temp_mathml_order = replace_order_with_value(
          self.temp_mathml_order,
          Array(value),
          "msup"
        )
      end

      def msub_value=(value)
        return if value.nil? || value.empty?

        self.temp_mathml_order = replace_order_with_value(
          self.temp_mathml_order,
          Array(value),
          "msub"
        )
      end

      def mtable_value=(value)
        return if value.nil? || value.empty?

        if self.respond_to?(:value)
          self.value = replace_order_with_value(
            self.value,
            Array(value),
            "mtable"
          )
        else
          self.temp_mathml_order = replace_order_with_value(
            self.temp_mathml_order,
            Array(value),
            "mtable"
          )
        end
      end

      def mtd_value=(value)
        return if value.nil? || value.empty?

        self.parameter_one = replace_order_with_value(
          self.temp_mathml_order,
          Array(update_temp_mathml_values(value)),
          "mtd"
        )
        self.temp_mathml_order.clear
      end

      def mtr_value=(value)
        return if value.nil? || value.empty?

        self.value = replace_order_with_value(
          Array(self.temp_mathml_order),
          Array(value),
          "mtr"
        )
        self.temp_mathml_order.clear
      end

      def msqrt_value=(value)
        return if value.nil? || value.empty?

        self.temp_mathml_order = replace_order_with_value(
          Array(self.temp_mathml_order),
          Array(value),
          "msqrt"
        )
      end

      def mfenced_value=(value)
        return if value.nil? || value.empty?

        self.temp_mathml_order = replace_order_with_value(
          Array(self.temp_mathml_order),
          Array(value),
          "mfenced"
        )
      end

      private

      # TODO: For testing purposes only and will/should be removed before release
      # we raise an error with the value that caused the error to handle that specific case
      def raise_development_error(value)
        raise Plurimath::Math::DevelopmentError,
              "Need to handle #{value.inspect} in #{caller_locations(1,
                                                                     1)[0].label}"
      end

      def filter_values(value, array_to_instance: false)
        return value unless value.is_a?(Array)
        return value if value.empty?

        if value.length == 1 && value.all? { |val| val.is_a?(Math::Formula) }
          if array_to_instance
            filter_values(value.first.value, array_to_instance: true)
          else
            value.first.value
          end
        elsif value_is_ternary_or_nary?(value)
          value.first.parameter_three = value.pop
          value
        elsif array_to_instance
          value.length > 1 ? Math::Formula.new(value) : value.first
        else
          value
        end
      end

      def validate_symbols(value)
        case value
        when Array
          value.each_with_index do |val, index|
            next unless val.is_a?(Math::Symbols::Symbol)

            value[index] = Plurimath::Utility.mathml_unary_classes(
              Array(val.value),
              lang: :mathml,
            )
          end
        when Math::Symbols::Symbol
          value = Plurimath::Utility.mathml_unary_classes(
            Array(value.value),
            lang: :mathml,
          )
        when String
          value = Plurimath::Utility.mathml_unary_classes(
            Array(value),
            lang: :mathml,
          )
        else
          raise_development_error(value)
        end
        value
      end

      def replace_order_with_value(order, value, tag_name)
        value_index = 0
        value_array = Array(value)

        order.each_with_object([]) do |item, result|
          case item
          when tag_name
            next if value_index >= value_array.length

            result << value_array[value_index]
            value_index += 1
          else
            result << item
          end
        end
      end

      def update_temp_mathml_values(value)
        value.each_with_index do |element, index|
          next unless element.respond_to?(:temp_mathml_order)
          next if element.temp_mathml_order.empty?
          next unless element.is_binary_function? ||
            element.is_ternary_function? ||
            element.is_unary?

          if element.is_ternary_function?
            next if element.temp_mathml_order.empty?

            if element.temp_mathml_order[0]&.is_ternary_function? &&
                !element.temp_mathml_order[0].any_value_exist?
              new_element = element.temp_mathml_order.shift
              new_element.parameter_one = element.temp_mathml_order.shift
              new_element.parameter_two = element.temp_mathml_order.shift
              value[index] = new_element
            elsif element.temp_mathml_order[0]&.is_binary_function? &&
                !element.temp_mathml_order[0].any_value_exist?
              new_element = element.temp_mathml_order.shift
              new_element.parameter_one = element.temp_mathml_order.shift
              new_element.parameter_two = element.temp_mathml_order.shift
              value[index] = new_element
            else
              element.parameter_one = element.temp_mathml_order.shift
              element.parameter_two = element.temp_mathml_order.shift
              element.parameter_three = element.temp_mathml_order.shift
            end
          elsif element.is_binary_function?
            next if element.temp_mathml_order.empty?

            case element
            when Math::Function::Overset
              element.parameter_two = element.temp_mathml_order.shift
              element.parameter_one = element.temp_mathml_order.shift
            when Math::Function::Power
              element.parameter_one = filter_values(
                Array(element.temp_mathml_order.shift),
                array_to_instance: true
              )
              element.parameter_two = filter_values(
                Array(element.temp_mathml_order.shift),
                array_to_instance: true
              )
            when Math::Function::Td
              element.parameter_one = element.temp_mathml_order.dup
              element.temp_mathml_order.clear
            else
              element.parameter_one = element.temp_mathml_order.shift
              element.parameter_two = element.temp_mathml_order.shift
            end
          elsif element.is_unary?
            case element
            when Math::Function::Sqrt
              element.parameter_one = element.temp_mathml_order.shift
            else
              element.parameter_one = element.temp_mathml_order
            end
          end
        end
        value
      end

      def validated_order(order)
        order.reject { |str| str == "text" }
      end

      def value_is_ternary_or_nary?(value)
        value.length == 2 && value.first.is_ternary_function?
      end
    end
  end
end
