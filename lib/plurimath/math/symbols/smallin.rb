module Plurimath
  module Math
    module Symbols
      class Smallin < Symbol
        INPUT = {
          unicodemath: [["&#x220a;"], parsing_wrapper(["smallin"], lang: :unicode)],
          asciimath: [["&#x220a;"], parsing_wrapper(["smallin"], lang: :asciimath)],
          mathml: ["&#x220a;"],
          latex: [["smallin", "&#x220a;"]],
          omml: ["&#x220a;"],
          html: ["&#x220a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\smallin"
        end

        def to_asciimath(**)
          parsing_wrapper("smallin", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x220a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x220a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x220a;"
        end

        def to_html(**)
          "&#x220a;"
        end
      end
    end
  end
end
