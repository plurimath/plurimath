module Plurimath
  module Math
    module Symbols
      class Veeonwedge < Symbol
        INPUT = {
          unicodemath: [["&#x2a59;"], parsing_wrapper(["veeonwedge"], lang: :unicode)],
          asciimath: [["&#x2a59;"], parsing_wrapper(["veeonwedge"], lang: :asciimath)],
          mathml: ["&#x2a59;"],
          latex: [["veeonwedge", "&#x2a59;"]],
          omml: ["&#x2a59;"],
          html: ["&#x2a59;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\veeonwedge"
        end

        def to_asciimath(**)
          parsing_wrapper("veeonwedge", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a59;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a59;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a59;"
        end

        def to_html(**)
          "&#x2a59;"
        end
      end
    end
  end
end
