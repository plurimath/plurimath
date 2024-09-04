module Plurimath
  module Math
    module Symbols
      class Dicevi < Symbol
        INPUT = {
          unicodemath: [["&#x2685;"], parsing_wrapper(["dicevi"], lang: :unicode)],
          asciimath: [["&#x2685;"], parsing_wrapper(["dicevi"], lang: :asciimath)],
          mathml: ["&#x2685;"],
          latex: [["dicevi", "&#x2685;"]],
          omml: ["&#x2685;"],
          html: ["&#x2685;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\dicevi"
        end

        def to_asciimath(**)
          parsing_wrapper("dicevi", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2685;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2685;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2685;"
        end

        def to_html(**)
          "&#x2685;"
        end
      end
    end
  end
end
