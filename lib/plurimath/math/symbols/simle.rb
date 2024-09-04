module Plurimath
  module Math
    module Symbols
      class Simle < Symbol
        INPUT = {
          unicodemath: [["&#x2a9f;"], parsing_wrapper(["simlE"], lang: :unicode)],
          asciimath: [["&#x2a9f;"], parsing_wrapper(["simlE"], lang: :asciimath)],
          mathml: ["&#x2a9f;"],
          latex: [["simlE", "&#x2a9f;"]],
          omml: ["&#x2a9f;"],
          html: ["&#x2a9f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\simlE"
        end

        def to_asciimath(**)
          parsing_wrapper("simlE", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a9f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a9f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a9f;"
        end

        def to_html(**)
          "&#x2a9f;"
        end
      end
    end
  end
end
