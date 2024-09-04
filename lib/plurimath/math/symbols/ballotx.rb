module Plurimath
  module Math
    module Symbols
      class Ballotx < Symbol
        INPUT = {
          unicodemath: [["&#x2717;"], parsing_wrapper(["ballotx"], lang: :unicode)],
          asciimath: [["&#x2717;"], parsing_wrapper(["ballotx"], lang: :asciimath)],
          mathml: ["&#x2717;"],
          latex: [["ballotx", "&#x2717;"]],
          omml: ["&#x2717;"],
          html: ["&#x2717;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ballotx"
        end

        def to_asciimath(**)
          parsing_wrapper("ballotx", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2717;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2717;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2717;"
        end

        def to_html(**)
          "&#x2717;"
        end
      end
    end
  end
end
