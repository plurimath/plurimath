module Plurimath
  module Math
    module Symbols
      class Eqqless < Symbol
        INPUT = {
          unicodemath: [["&#x2a99;"], parsing_wrapper(["eqqless"], lang: :unicode)],
          asciimath: [["&#x2a99;"], parsing_wrapper(["eqqless"], lang: :asciimath)],
          mathml: ["&#x2a99;"],
          latex: [["eqqless", "&#x2a99;"]],
          omml: ["&#x2a99;"],
          html: ["&#x2a99;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\eqqless"
        end

        def to_asciimath(**)
          parsing_wrapper("eqqless", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a99;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a99;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a99;"
        end

        def to_html(**)
          "&#x2a99;"
        end
      end
    end
  end
end
