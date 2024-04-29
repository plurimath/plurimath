module Plurimath
  module Math
    module Symbols
      class Whitepointerright < Symbol
        INPUT = {
          unicodemath: [["&#x25bb;"], parsing_wrapper(["whitepointerright"])],
          asciimath: [["&#x25bb;"], parsing_wrapper(["whitepointerright"])],
          mathml: ["&#x25bb;"],
          latex: [["whitepointerright", "&#x25bb;"]],
          omml: ["&#x25bb;"],
          html: ["&#x25bb;"],
        }.freeze

        # output methods
        def to_latex
          "\\whitepointerright"
        end

        def to_asciimath
          parsing_wrapper("whitepointerright")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x25bb;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x25bb;"
        end

        def to_omml_without_math_tag(_)
          "&#x25bb;"
        end

        def to_html
          "&#x25bb;"
        end
      end
    end
  end
end
