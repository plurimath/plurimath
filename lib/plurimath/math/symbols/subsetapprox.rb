module Plurimath
  module Math
    module Symbols
      class Subsetapprox < Symbol
        INPUT = {
          unicodemath: [["&#x2ac9;"], parsing_wrapper(["subsetapprox"], lang: :unicode)],
          asciimath: [["&#x2ac9;"], parsing_wrapper(["subsetapprox"], lang: :asciimath)],
          mathml: ["&#x2ac9;"],
          latex: [["subsetapprox", "&#x2ac9;"]],
          omml: ["&#x2ac9;"],
          html: ["&#x2ac9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\subsetapprox"
        end

        def to_asciimath(**)
          parsing_wrapper("subsetapprox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ac9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ac9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ac9;"
        end

        def to_html(**)
          "&#x2ac9;"
        end
      end
    end
  end
end
