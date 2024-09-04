module Plurimath
  module Math
    module Symbols
      class Sanslturned < Symbol
        INPUT = {
          unicodemath: [["&#x2142;"], parsing_wrapper(["sansLturned"], lang: :unicode)],
          asciimath: [["&#x2142;"], parsing_wrapper(["sansLturned"], lang: :asciimath)],
          mathml: ["&#x2142;"],
          latex: [["sansLturned", "&#x2142;"]],
          omml: ["&#x2142;"],
          html: ["&#x2142;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sansLturned"
        end

        def to_asciimath(**)
          parsing_wrapper("sansLturned", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2142;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2142;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2142;"
        end

        def to_html(**)
          "&#x2142;"
        end
      end
    end
  end
end
