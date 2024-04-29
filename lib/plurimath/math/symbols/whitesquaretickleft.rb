module Plurimath
  module Math
    module Symbols
      class Whitesquaretickleft < Symbol
        INPUT = {
          unicodemath: [["&#x27e4;"], parsing_wrapper(["whitesquaretickleft"])],
          asciimath: [["&#x27e4;"], parsing_wrapper(["whitesquaretickleft"])],
          mathml: ["&#x27e4;"],
          latex: [["whitesquaretickleft", "&#x27e4;"]],
          omml: ["&#x27e4;"],
          html: ["&#x27e4;"],
        }.freeze

        # output methods
        def to_latex
          "\\whitesquaretickleft"
        end

        def to_asciimath
          parsing_wrapper("whitesquaretickleft")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x27e4;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x27e4;"
        end

        def to_omml_without_math_tag(_)
          "&#x27e4;"
        end

        def to_html
          "&#x27e4;"
        end
      end
    end
  end
end
