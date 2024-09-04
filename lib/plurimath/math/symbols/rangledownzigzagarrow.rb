module Plurimath
  module Math
    module Symbols
      class Rangledownzigzagarrow < Symbol
        INPUT = {
          unicodemath: [["&#x237c;"], parsing_wrapper(["rangledownzigzagarrow"], lang: :unicode)],
          asciimath: [["&#x237c;"], parsing_wrapper(["rangledownzigzagarrow"], lang: :asciimath)],
          mathml: ["&#x237c;"],
          latex: [["rangledownzigzagarrow", "&#x237c;"]],
          omml: ["&#x237c;"],
          html: ["&#x237c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rangledownzigzagarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("rangledownzigzagarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x237c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x237c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x237c;"
        end

        def to_html(**)
          "&#x237c;"
        end
      end
    end
  end
end
