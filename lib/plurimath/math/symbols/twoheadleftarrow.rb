module Plurimath
  module Math
    module Symbols
      class Twoheadleftarrow < Symbol
        INPUT = {
          unicodemath: [["twoheadleftarrow", "&#x219e;"]],
          asciimath: [["&#x219e;"], parsing_wrapper(["twoheadleftarrow"], lang: :asciimath)],
          mathml: ["&#x219e;"],
          latex: [["twoheadleftarrow", "&#x219e;"]],
          omml: ["&#x219e;"],
          html: ["&#x219e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\twoheadleftarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("twoheadleftarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x219e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x219e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x219e;"
        end

        def to_html(**)
          "&#x219e;"
        end
      end
    end
  end
end
