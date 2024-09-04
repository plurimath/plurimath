module Plurimath
  module Math
    module Symbols
      class Supedot < Symbol
        INPUT = {
          unicodemath: [["&#x2ac4;"], parsing_wrapper(["supedot"], lang: :unicode)],
          asciimath: [["&#x2ac4;"], parsing_wrapper(["supedot"], lang: :asciimath)],
          mathml: ["&#x2ac4;"],
          latex: [["supedot", "&#x2ac4;"]],
          omml: ["&#x2ac4;"],
          html: ["&#x2ac4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\supedot"
        end

        def to_asciimath(**)
          parsing_wrapper("supedot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ac4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ac4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ac4;"
        end

        def to_html(**)
          "&#x2ac4;"
        end
      end
    end
  end
end
