module Plurimath
  module Math
    module Symbols
      class Digamma < Symbol
        INPUT = {
          unicodemath: [["&#x3dd;"], parsing_wrapper(["updigamma", "digamma"], lang: :unicode)],
          asciimath: [["&#x3dd;"], parsing_wrapper(["updigamma", "digamma"], lang: :asciimath)],
          mathml: ["&#x3dd;"],
          latex: [["updigamma", "digamma", "&#x3dd;"]],
          omml: ["&#x3dd;"],
          html: ["&#x3dd;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\updigamma"
        end

        def to_asciimath(**)
          parsing_wrapper("digamma", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3dd;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3dd;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3dd;"
        end

        def to_html(**)
          "&#x3dd;"
        end
      end
    end
  end
end
