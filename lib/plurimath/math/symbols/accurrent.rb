module Plurimath
  module Math
    module Symbols
      class Accurrent < Symbol
        INPUT = {
          unicodemath: [["&#x23e6;"], parsing_wrapper(["accurrent"], lang: :unicode)],
          asciimath: [["&#x23e6;"], parsing_wrapper(["accurrent"], lang: :asciimath)],
          mathml: ["&#x23e6;"],
          latex: [["accurrent", "&#x23e6;"]],
          omml: ["&#x23e6;"],
          html: ["&#x23e6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\accurrent"
        end

        def to_asciimath(**)
          parsing_wrapper("accurrent", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23e6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23e6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23e6;"
        end

        def to_html(**)
          "&#x23e6;"
        end
      end
    end
  end
end
