module Plurimath
  module Math
    module Symbols
      class Lmoust < Symbol
        INPUT = {
          unicodemath: [["lmoust", "&#x22b0;"], parsing_wrapper(["prurel"])],
          asciimath: [["&#x22b0;"], parsing_wrapper(["lmoust", "prurel"])],
          mathml: ["&#x22b0;"],
          latex: [["prurel", "&#x22b0;"], parsing_wrapper(["lmoust"])],
          omml: ["&#x22b0;"],
          html: ["&#x22b0;"],
        }.freeze

        # output methods
        def to_latex
          "\\prurel"
        end

        def to_asciimath
          parsing_wrapper("lmoust")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x22b0;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x22b0;"
        end

        def to_omml_without_math_tag(_)
          "&#x22b0;"
        end

        def to_html
          "&#x22b0;"
        end
      end
    end
  end
end
