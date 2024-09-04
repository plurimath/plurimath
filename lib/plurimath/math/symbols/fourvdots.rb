module Plurimath
  module Math
    module Symbols
      class Fourvdots < Symbol
        INPUT = {
          unicodemath: [["&#x2999;"], parsing_wrapper(["fourvdots"], lang: :unicode)],
          asciimath: [["&#x2999;"], parsing_wrapper(["fourvdots"], lang: :asciimath)],
          mathml: ["&#x2999;"],
          latex: [["fourvdots", "&#x2999;"]],
          omml: ["&#x2999;"],
          html: ["&#x2999;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\fourvdots"
        end

        def to_asciimath(**)
          parsing_wrapper("fourvdots", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2999;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2999;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2999;"
        end

        def to_html(**)
          "&#x2999;"
        end
      end
    end
  end
end
