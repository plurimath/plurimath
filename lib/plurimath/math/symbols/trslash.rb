module Plurimath
  module Math
    module Symbols
      class Trslash < Symbol
        INPUT = {
          unicodemath: [["&#x2afb;"], parsing_wrapper(["trslash"], lang: :unicode)],
          asciimath: [["&#x2afb;"], parsing_wrapper(["trslash"], lang: :asciimath)],
          mathml: ["&#x2afb;"],
          latex: [["trslash", "&#x2afb;"]],
          omml: ["&#x2afb;"],
          html: ["&#x2afb;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\trslash"
        end

        def to_asciimath(**)
          parsing_wrapper("trslash", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2afb;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2afb;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2afb;"
        end

        def to_html(**)
          "&#x2afb;"
        end
      end
    end
  end
end
