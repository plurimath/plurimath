module Plurimath
  module Math
    module Symbols
      class Midbarwedge < Symbol
        INPUT = {
          unicodemath: [["&#x2a5c;"], parsing_wrapper(["midbarwedge"], lang: :unicode)],
          asciimath: [["&#x2a5c;"], parsing_wrapper(["midbarwedge"], lang: :asciimath)],
          mathml: ["&#x2a5c;"],
          latex: [["midbarwedge", "&#x2a5c;"]],
          omml: ["&#x2a5c;"],
          html: ["&#x2a5c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\midbarwedge"
        end

        def to_asciimath(**)
          parsing_wrapper("midbarwedge", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a5c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a5c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a5c;"
        end

        def to_html(**)
          "&#x2a5c;"
        end
      end
    end
  end
end
