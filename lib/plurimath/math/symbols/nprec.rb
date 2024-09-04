module Plurimath
  module Math
    module Symbols
      class Nprec < Symbol
        INPUT = {
          unicodemath: [["nprec", "&#x2280;"]],
          asciimath: [["&#x2280;"], parsing_wrapper(["nprec"], lang: :asciimath)],
          mathml: ["&#x2280;"],
          latex: [["nprec", "&#x2280;"]],
          omml: ["&#x2280;"],
          html: ["&#x2280;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nprec"
        end

        def to_asciimath(**)
          parsing_wrapper("nprec", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2280;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2280;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2280;"
        end

        def to_html(**)
          "&#x2280;"
        end
      end
    end
  end
end
