module Plurimath
  module Math
    module Symbols
      class Eqqslantless < Symbol
        INPUT = {
          unicodemath: [["&#x2a9b;"], parsing_wrapper(["eqqslantless"], lang: :unicode)],
          asciimath: [["&#x2a9b;"], parsing_wrapper(["eqqslantless"], lang: :asciimath)],
          mathml: ["&#x2a9b;"],
          latex: [["eqqslantless", "&#x2a9b;"]],
          omml: ["&#x2a9b;"],
          html: ["&#x2a9b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\eqqslantless"
        end

        def to_asciimath(**)
          parsing_wrapper("eqqslantless", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a9b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a9b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a9b;"
        end

        def to_html(**)
          "&#x2a9b;"
        end
      end
    end
  end
end
