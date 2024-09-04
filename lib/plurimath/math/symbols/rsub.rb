module Plurimath
  module Math
    module Symbols
      class Rsub < Symbol
        INPUT = {
          unicodemath: [["&#x2a65;"], parsing_wrapper(["nrres", "rsub"], lang: :unicode)],
          asciimath: [["&#x2a65;"], parsing_wrapper(["nrres", "rsub"], lang: :asciimath)],
          mathml: ["&#x2a65;"],
          latex: [["nrres", "rsub", "&#x2a65;"]],
          omml: ["&#x2a65;"],
          html: ["&#x2a65;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nrres"
        end

        def to_asciimath(**)
          parsing_wrapper("rsub", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a65;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a65;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a65;"
        end

        def to_html(**)
          "&#x2a65;"
        end
      end
    end
  end
end
