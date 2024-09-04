module Plurimath
  module Math
    module Symbols
      class Whitepointerleft < Symbol
        INPUT = {
          unicodemath: [["&#x25c5;"], parsing_wrapper(["whitepointerleft"], lang: :unicode)],
          asciimath: [["&#x25c5;"], parsing_wrapper(["whitepointerleft"], lang: :asciimath)],
          mathml: ["&#x25c5;"],
          latex: [["whitepointerleft", "&#x25c5;"]],
          omml: ["&#x25c5;"],
          html: ["&#x25c5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\whitepointerleft"
        end

        def to_asciimath(**)
          parsing_wrapper("whitepointerleft", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25c5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25c5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25c5;"
        end

        def to_html(**)
          "&#x25c5;"
        end
      end
    end
  end
end
