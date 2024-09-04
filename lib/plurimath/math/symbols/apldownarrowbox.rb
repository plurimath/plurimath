module Plurimath
  module Math
    module Symbols
      class Apldownarrowbox < Symbol
        INPUT = {
          unicodemath: [["&#x2357;"], parsing_wrapper(["APLdownarrowbox"], lang: :unicode)],
          asciimath: [["&#x2357;"], parsing_wrapper(["APLdownarrowbox"], lang: :asciimath)],
          mathml: ["&#x2357;"],
          latex: [["APLdownarrowbox", "&#x2357;"]],
          omml: ["&#x2357;"],
          html: ["&#x2357;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\APLdownarrowbox"
        end

        def to_asciimath(**)
          parsing_wrapper("APLdownarrowbox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2357;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2357;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2357;"
        end

        def to_html(**)
          "&#x2357;"
        end
      end
    end
  end
end
