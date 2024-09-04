module Plurimath
  module Math
    module Symbols
      class Fltns < Symbol
        INPUT = {
          unicodemath: [["&#x23e5;"], parsing_wrapper(["fltns"], lang: :unicode)],
          asciimath: [["&#x23e5;"], parsing_wrapper(["fltns"], lang: :asciimath)],
          mathml: ["&#x23e5;"],
          latex: [["fltns", "&#x23e5;"]],
          omml: ["&#x23e5;"],
          html: ["&#x23e5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\fltns"
        end

        def to_asciimath(**)
          parsing_wrapper("fltns", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23e5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23e5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23e5;"
        end

        def to_html(**)
          "&#x23e5;"
        end
      end
    end
  end
end
