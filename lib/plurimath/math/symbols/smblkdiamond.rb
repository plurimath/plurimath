module Plurimath
  module Math
    module Symbols
      class Smblkdiamond < Symbol
        INPUT = {
          unicodemath: [["&#x2b29;"], parsing_wrapper(["smblkdiamond"])],
          asciimath: [["&#x2b29;"], parsing_wrapper(["smblkdiamond"])],
          mathml: ["&#x2b29;"],
          latex: [["smblkdiamond", "&#x2b29;"]],
          omml: ["&#x2b29;"],
          html: ["&#x2b29;"],
        }.freeze

        # output methods
        def to_latex
          "\\smblkdiamond"
        end

        def to_asciimath
          parsing_wrapper("smblkdiamond")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2b29;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2b29;"
        end

        def to_omml_without_math_tag(_)
          "&#x2b29;"
        end

        def to_html
          "&#x2b29;"
        end
      end
    end
  end
end
