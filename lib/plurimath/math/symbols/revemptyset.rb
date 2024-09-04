module Plurimath
  module Math
    module Symbols
      class Revemptyset < Symbol
        INPUT = {
          unicodemath: [["&#x29b0;"], parsing_wrapper(["revemptyset"], lang: :unicode)],
          asciimath: [["&#x29b0;"], parsing_wrapper(["revemptyset"], lang: :asciimath)],
          mathml: ["&#x29b0;"],
          latex: [["revemptyset", "&#x29b0;"]],
          omml: ["&#x29b0;"],
          html: ["&#x29b0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\revemptyset"
        end

        def to_asciimath(**)
          parsing_wrapper("revemptyset", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29b0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29b0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29b0;"
        end

        def to_html(**)
          "&#x29b0;"
        end
      end
    end
  end
end
