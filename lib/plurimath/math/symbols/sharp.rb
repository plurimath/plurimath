module Plurimath
  module Math
    module Symbols
      class Sharp < Symbol
        INPUT = {
          unicodemath: [["&#x266f;"], parsing_wrapper(["sharp"], lang: :unicode)],
          asciimath: [["&#x266f;"], parsing_wrapper(["sharp"], lang: :asciimath)],
          mathml: ["&#x266f;"],
          latex: [["sharp", "&#x266f;"]],
          omml: ["&#x266f;"],
          html: ["&#x266f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sharp"
        end

        def to_asciimath(**)
          parsing_wrapper("sharp", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x266f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x266f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x266f;"
        end

        def to_html(**)
          "&#x266f;"
        end
      end
    end
  end
end
