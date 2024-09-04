module Plurimath
  module Math
    module Symbols
      class Nparallel < Symbol
        INPUT = {
          unicodemath: [["nparallel", "&#x2226;"]],
          asciimath: [["&#x2226;"], parsing_wrapper(["nparallel"], lang: :asciimath)],
          mathml: ["&#x2226;"],
          latex: [["nparallel", "&#x2226;"]],
          omml: ["&#x2226;"],
          html: ["&#x2226;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nparallel"
        end

        def to_asciimath(**)
          parsing_wrapper("nparallel", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2226;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2226;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2226;"
        end

        def to_html(**)
          "&#x2226;"
        end
      end
    end
  end
end
