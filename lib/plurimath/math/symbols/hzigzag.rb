module Plurimath
  module Math
    module Symbols
      class Hzigzag < Symbol
        INPUT = {
          unicodemath: [["&#x3030;"], parsing_wrapper(["hzigzag"], lang: :unicode)],
          asciimath: [["&#x3030;"], parsing_wrapper(["hzigzag"], lang: :asciimath)],
          mathml: ["&#x3030;"],
          latex: [["hzigzag", "&#x3030;"]],
          omml: ["&#x3030;"],
          html: ["&#x3030;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\hzigzag"
        end

        def to_asciimath(**)
          parsing_wrapper("hzigzag", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3030;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3030;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3030;"
        end

        def to_html(**)
          "&#x3030;"
        end
      end
    end
  end
end
