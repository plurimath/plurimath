module Plurimath
  module Math
    module Symbols
      class Supsetdot < Symbol
        INPUT = {
          unicodemath: [["&#x2abe;"], parsing_wrapper(["supsetdot"], lang: :unicode)],
          asciimath: [["&#x2abe;"], parsing_wrapper(["supsetdot"], lang: :asciimath)],
          mathml: ["&#x2abe;"],
          latex: [["supsetdot", "&#x2abe;"]],
          omml: ["&#x2abe;"],
          html: ["&#x2abe;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\supsetdot"
        end

        def to_asciimath(**)
          parsing_wrapper("supsetdot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2abe;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2abe;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2abe;"
        end

        def to_html(**)
          "&#x2abe;"
        end
      end
    end
  end
end
