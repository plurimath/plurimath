module Plurimath
  module Math
    module Symbols
      class Draftingarrow < Symbol
        INPUT = {
          unicodemath: [["&#x279b;"], parsing_wrapper(["draftingarrow"], lang: :unicode)],
          asciimath: [["&#x279b;"], parsing_wrapper(["draftingarrow"], lang: :asciimath)],
          mathml: ["&#x279b;"],
          latex: [["draftingarrow", "&#x279b;"]],
          omml: ["&#x279b;"],
          html: ["&#x279b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\draftingarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("draftingarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x279b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x279b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x279b;"
        end

        def to_html(**)
          "&#x279b;"
        end
      end
    end
  end
end
