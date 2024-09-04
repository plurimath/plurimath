module Plurimath
  module Math
    module Symbols
      class Leftarrowtail < Symbol
        INPUT = {
          unicodemath: [["leftarrowtail", "&#x21a2;"]],
          asciimath: [["&#x21a2;"], parsing_wrapper(["leftarrowtail"], lang: :asciimath)],
          mathml: ["&#x21a2;"],
          latex: [["leftarrowtail", "&#x21a2;"]],
          omml: ["&#x21a2;"],
          html: ["&#x21a2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftarrowtail"
        end

        def to_asciimath(**)
          parsing_wrapper("leftarrowtail", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21a2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21a2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21a2;"
        end

        def to_html(**)
          "&#x21a2;"
        end
      end
    end
  end
end
