module Plurimath
  module Math
    module Symbols
      class Vysmblksquare < Symbol
        INPUT = {
          unicodemath: [["&#x2b1d;"], parsing_wrapper(["vysmblksquare"], lang: :unicode)],
          asciimath: [["&#x2b1d;"], parsing_wrapper(["vysmblksquare"], lang: :asciimath)],
          mathml: ["&#x2b1d;"],
          latex: [["vysmblksquare", "&#x2b1d;"]],
          omml: ["&#x2b1d;"],
          html: ["&#x2b1d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\vysmblksquare"
        end

        def to_asciimath(**)
          parsing_wrapper("vysmblksquare", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b1d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b1d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b1d;"
        end

        def to_html(**)
          "&#x2b1d;"
        end
      end
    end
  end
end
