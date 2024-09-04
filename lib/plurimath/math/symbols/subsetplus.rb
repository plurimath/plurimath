module Plurimath
  module Math
    module Symbols
      class Subsetplus < Symbol
        INPUT = {
          unicodemath: [["&#x2abf;"], parsing_wrapper(["subsetplus"], lang: :unicode)],
          asciimath: [["&#x2abf;"], parsing_wrapper(["subsetplus"], lang: :asciimath)],
          mathml: ["&#x2abf;"],
          latex: [["subsetplus", "&#x2abf;"]],
          omml: ["&#x2abf;"],
          html: ["&#x2abf;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\subsetplus"
        end

        def to_asciimath(**)
          parsing_wrapper("subsetplus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2abf;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2abf;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2abf;"
        end

        def to_html(**)
          "&#x2abf;"
        end
      end
    end
  end
end
