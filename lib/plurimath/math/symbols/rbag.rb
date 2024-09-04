module Plurimath
  module Math
    module Symbols
      class Rbag < Symbol
        INPUT = {
          unicodemath: [["&#x27c6;"], parsing_wrapper(["Rbag", "rbag"], lang: :unicode)],
          asciimath: [["&#x27c6;"], parsing_wrapper(["Rbag", "rbag"], lang: :asciimath)],
          mathml: ["&#x27c6;"],
          latex: [["Rbag", "rbag", "&#x27c6;"]],
          omml: ["&#x27c6;"],
          html: ["&#x27c6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Rbag"
        end

        def to_asciimath(**)
          parsing_wrapper("rbag", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27c6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27c6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27c6;"
        end

        def to_html(**)
          "&#x27c6;"
        end
      end
    end
  end
end
