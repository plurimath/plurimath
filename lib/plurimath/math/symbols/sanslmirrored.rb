module Plurimath
  module Math
    module Symbols
      class Sanslmirrored < Symbol
        INPUT = {
          unicodemath: [["&#x2143;"], parsing_wrapper(["sansLmirrored"], lang: :unicode)],
          asciimath: [["&#x2143;"], parsing_wrapper(["sansLmirrored"], lang: :asciimath)],
          mathml: ["&#x2143;"],
          latex: [["sansLmirrored", "&#x2143;"]],
          omml: ["&#x2143;"],
          html: ["&#x2143;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sansLmirrored"
        end

        def to_asciimath(**)
          parsing_wrapper("sansLmirrored", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2143;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2143;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2143;"
        end

        def to_html(**)
          "&#x2143;"
        end
      end
    end
  end
end
