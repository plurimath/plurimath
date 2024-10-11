# frozen_string_literal: true

module Plurimath
  class Mathml
    module Utility
      # START OF MI/MROW ATTRIBUTES
      def mi(symbol)
        return unless symbol

        if symbol.mathcolor || symbol.color
          Math::Function::Color.new(
            symbol,
            symbol.mathcolor || symbol.color
          )
        elsif symbol.mathbackground || symbol.background
          Math::Function::Color.new(
            symbol,
            symbol.mathbackground || symbol.background,
            { backgroundcolor: true }
          )
        else
          symbol
        end
      end

      def mglyph=(value)
        return if value.empty?

        puts "mglyph => #{value}"
      end

      def validate_symbols(value)
        if value.is_a?(Array)
          value.each_with_index do |val, index|
            next unless val.is_a?(Math::Symbols::Symbol)

            value[index] = Plurimath::Utility.symbols_class(
              Plurimath::Utility.string_to_html_entity(val.value),
              lang: :mathml,
            )
          end
        else
          raise_development_error(value)
        end
      end

      def malignmark=(value);end

      def mathcolor=(value);end

      def mathbackground=(value);end

      def mathvariant=(value);end

      def mathsize=(value);end

      def dir=(value);end

      def fontfamily=(value);end

      def fontweight=(value);end

      def fontstyle=(value);end

      def fontsize=(value);end

      def color=(value);end

      def mathbackgroundcolor=(value);end

      def background=(value);end
      # END OF MI/MROW ATTRIBUTES

      def scriptlevel=(value); end
      def displaystyle=(value); end
      def scriptsizemultiplier=(value); end
      def scriptminsize=(value); end
      def infixlinebreakstyle=(value); end
      def decimalpoint=(value); end
      def accent=(value); end
      def accentunder=(value); end
      def align=(value); end
      def alignmentscope=(value); end
      def bevelled=(value); end
      def charalign=(value); end
      def charspacing=(value); end
      def close=(value); end
      def columnalign=(value); end
      def columnlines=(value); end
      def columnspacing=(value); end
      def columnspan=(value); end
      def columnwidth=(value); end
      def crossout=(value); end
      def denomalign=(value); end
      def depth=(value); end
      def edge=(value); end
      def equalcolumns=(value); end
      def equalrows=(value); end
      def fence=(value); end
      def form=(value); end
      def frame=(value); end
      def framespacing=(value); end
      def groupalign=(value); end
      def height=(value); end
      def indentalign=(value); end
      def indentalignfirst=(value); end
      def indentalignlast=(value); end
      def indentshift=(value); end
      def indentshiftfirst=(value); end
      def indentshiftlast=(value); end
      def indenttarget=(value); end
      def largeop=(value); end
      def leftoverhang=(value); end
      def length=(value); end
      def linebreak=(value); end
      def linebreakmultchar=(value); end
      def linebreakstyle=(value); end
      def lineleading=(value); end
      def linethickness=(value); end
      def location=(value); end
      def longdivstyle=(value); end
      def lquote=(value); end
      def lspace=(value); end
      def maxsize=(value); end
      def minlabelspacing=(value); end
      def minsize=(value); end
      def movablelimits=(value); end
      def mslinethickness=(value); end
      def notation=(value); end
      def numalign=(value); end
      def open=(value); end
      def position=(value); end
      def rightoverhang=(value); end
      def rowalign=(value); end
      def rowlines=(value); end
      def rowspacing=(value); end
      def rowspan=(value); end
      def rquote=(value); end
      def rspace=(value); end
      def selection=(value); end
      def separator=(value); end
      def separators=(value); end
      def shift=(value); end
      def side=(value); end
      def stackalign=(value); end
      def stretchy=(value); end
      def subscriptshift=(value); end
      def superscriptshift=(value); end
      def symmetric=(value); end
      def valign=(value); end
      def width=(value); end
      def veryverythinmathspace=(value); end
      def verythinmathspace=(value); end
      def thinmathspace=(value); end
      def mediummathspace=(value); end
      def thickmathspace=(value); end
      def verythickmathspace=(value); end
      def veryverythickmathspace=(value); end

      private

      # TODO: For testing purposes only and will/should be removed before release
      # we raise an error with the value that caused the error to handle that specific case
      def raise_development_error(value)
        raise Plurimath::Math::DevelopmentError, "Need to handle #{value.inspect} in #{caller_locations(1, 1)[0].label}"
      end

      def sort_element_by_attributes(element)
        order = element.element_order.reject { |item| item == "text" }
        element.class.attributes.each do |attr, _attr_value|
          attr_value = element.send(attr)
          next if attr_value.nil? || attr_value.empty?
          next unless order.include?(attr.to_s)

          order.each_with_index do |item, index|
            if item == attr.to_s
              order[index] = attr_value
            else
              puts "Skipping #{item} from #{order} on index #{index}"
            end
          end
        end
        order.flatten
      end

      def filter_values(value)
        if value.all? { |val| val.is_a?(Math::Formula) } && value.length == 1
          value.first.value
        else
          value
        end
      end
    end
  end
end
