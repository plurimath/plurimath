module Plurimath
  module Math
    module Symbols
      class Wedgedot < Symbol
        INPUT = {
          unicodemath: [["&#x27d1;"], parsing_wrapper(["wedgedot"], lang: :unicode)],
          asciimath: [["&#x27d1;"], parsing_wrapper(["wedgedot"], lang: :asciimath)],
          mathml: ["&#x27d1;"],
          latex: [["wedgedot", "&#x27d1;"]],
          omml: ["&#x27d1;"],
          html: ["&#x27d1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\wedgedot"
        end

        def to_asciimath(**)
          parsing_wrapper("wedgedot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27d1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27d1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27d1;"
        end

        def to_html(**)
          "&#x27d1;"
        end
      end
    end
  end
end
