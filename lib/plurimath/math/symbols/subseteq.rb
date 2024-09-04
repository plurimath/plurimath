module Plurimath
  module Math
    module Symbols
      class Subseteq < Symbol
        INPUT = {
          unicodemath: [["subseteq", "nsupseteq", "&#x2288;"], parsing_wrapper(["nsubseteq"], lang: :unicode)],
          asciimath: [["&#x2288;"], parsing_wrapper(["subseteq", "nsupseteq", "nsubseteq"], lang: :asciimath)],
          mathml: ["&#x2288;"],
          latex: [["nsubseteq", "&#x2288;"], parsing_wrapper(["subseteq", "nsupseteq"], lang: :latex)],
          omml: ["&#x2288;"],
          html: ["&#x2288;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nsubseteq"
        end

        def to_asciimath(**)
          parsing_wrapper("subseteq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2288;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2288;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2288;"
        end

        def to_html(**)
          "&#x2288;"
        end
      end
    end
  end
end
