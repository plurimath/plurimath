module Plurimath
  module Math
    module Symbols
      class Wedgeonwedge < Symbol
        INPUT = {
          unicodemath: [["&#x2a55;"], parsing_wrapper(["wedgeonwedge"], lang: :unicode)],
          asciimath: [["&#x2a55;"], parsing_wrapper(["wedgeonwedge"], lang: :asciimath)],
          mathml: ["&#x2a55;"],
          latex: [["wedgeonwedge", "&#x2a55;"]],
          omml: ["&#x2a55;"],
          html: ["&#x2a55;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\wedgeonwedge"
        end

        def to_asciimath(**)
          parsing_wrapper("wedgeonwedge", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a55;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a55;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a55;"
        end

        def to_html(**)
          "&#x2a55;"
        end
      end
    end
  end
end
