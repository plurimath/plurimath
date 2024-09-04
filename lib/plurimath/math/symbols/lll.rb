module Plurimath
  module Math
    module Symbols
      class Lll < Symbol
        INPUT = {
          unicodemath: [["&#x22d8;"], parsing_wrapper(["lll"], lang: :unicode)],
          asciimath: [["&#x22d8;"], parsing_wrapper(["lll"], lang: :asciimath)],
          mathml: ["&#x22d8;"],
          latex: [["lll", "&#x22d8;"]],
          omml: ["&#x22d8;"],
          html: ["&#x22d8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lll"
        end

        def to_asciimath(**)
          parsing_wrapper("lll", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22d8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22d8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22d8;"
        end

        def to_html(**)
          "&#x22d8;"
        end
      end
    end
  end
end
