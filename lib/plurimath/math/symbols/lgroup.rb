module Plurimath
  module Math
    module Symbols
      class Lgroup < Symbol
        INPUT = {
          unicodemath: [["&#x27ee;"], parsing_wrapper(["lgroup"], lang: :unicode)],
          asciimath: [["&#x27ee;"], parsing_wrapper(["lgroup"], lang: :asciimath)],
          mathml: ["&#x27ee;"],
          latex: [["lgroup", "&#x27ee;"]],
          omml: ["&#x27ee;"],
          html: ["&#x27ee;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lgroup"
        end

        def to_asciimath(**)
          parsing_wrapper("lgroup", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27ee;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27ee;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27ee;"
        end

        def to_html(**)
          "&#x27ee;"
        end
      end
    end
  end
end
