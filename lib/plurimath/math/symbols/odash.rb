module Plurimath
  module Math
    module Symbols
      class Odash < Symbol
        INPUT = {
          unicodemath: [["odash", "&#x229d;"], parsing_wrapper(["circleddash"], lang: :unicode)],
          asciimath: [["&#x229d;"], parsing_wrapper(["odash", "circleddash"], lang: :asciimath)],
          mathml: ["&#x229d;"],
          latex: [["circleddash", "&#x229d;"], parsing_wrapper(["odash"], lang: :latex)],
          omml: ["&#x229d;"],
          html: ["&#x229d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circleddash"
        end

        def to_asciimath(**)
          parsing_wrapper("odash", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x229d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x229d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x229d;"
        end

        def to_html(**)
          "&#x229d;"
        end
      end
    end
  end
end
