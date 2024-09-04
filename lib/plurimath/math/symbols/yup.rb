module Plurimath
  module Math
    module Symbols
      class Yup < Symbol
        INPUT = {
          unicodemath: [["&#x2144;"], parsing_wrapper(["Yup"], lang: :unicode)],
          asciimath: [["&#x2144;"], parsing_wrapper(["Yup"], lang: :asciimath)],
          mathml: ["&#x2144;"],
          latex: [["Yup", "&#x2144;"]],
          omml: ["&#x2144;"],
          html: ["&#x2144;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Yup"
        end

        def to_asciimath(**)
          parsing_wrapper("Yup", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2144;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2144;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2144;"
        end

        def to_html(**)
          "&#x2144;"
        end
      end
    end
  end
end
