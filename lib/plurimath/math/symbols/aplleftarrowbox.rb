module Plurimath
  module Math
    module Symbols
      class Aplleftarrowbox < Symbol
        INPUT = {
          unicodemath: [["&#x2347;"], parsing_wrapper(["APLleftarrowbox"], lang: :unicode)],
          asciimath: [["&#x2347;"], parsing_wrapper(["APLleftarrowbox"], lang: :asciimath)],
          mathml: ["&#x2347;"],
          latex: [["APLleftarrowbox", "&#x2347;"]],
          omml: ["&#x2347;"],
          html: ["&#x2347;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\APLleftarrowbox"
        end

        def to_asciimath(**)
          parsing_wrapper("APLleftarrowbox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2347;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2347;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2347;"
        end

        def to_html(**)
          "&#x2347;"
        end
      end
    end
  end
end
