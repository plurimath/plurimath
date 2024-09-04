module Plurimath
  module Math
    module Symbols
      class Varkappa < Symbol
        INPUT = {
          unicodemath: [["varkappa", "&#x3f0;"], parsing_wrapper(["upvarkappa"], lang: :unicode)],
          asciimath: [["&#x3f0;"], parsing_wrapper(["varkappa", "upvarkappa"], lang: :asciimath)],
          mathml: ["&#x3f0;"],
          latex: [["upvarkappa", "varkappa", "&#x3f0;"]],
          omml: ["&#x3f0;"],
          html: ["&#x3f0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upvarkappa"
        end

        def to_asciimath(**)
          parsing_wrapper("varkappa", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3f0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3f0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3f0;"
        end

        def to_html(**)
          "&#x3f0;"
        end
      end
    end
  end
end
