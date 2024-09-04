module Plurimath
  module Math
    module Symbols
      class Forkv < Symbol
        INPUT = {
          unicodemath: [["&#x2ad9;"], parsing_wrapper(["forkv"], lang: :unicode)],
          asciimath: [["&#x2ad9;"], parsing_wrapper(["forkv"], lang: :asciimath)],
          mathml: ["&#x2ad9;"],
          latex: [["forkv", "&#x2ad9;"]],
          omml: ["&#x2ad9;"],
          html: ["&#x2ad9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\forkv"
        end

        def to_asciimath(**)
          parsing_wrapper("forkv", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ad9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ad9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ad9;"
        end

        def to_html(**)
          "&#x2ad9;"
        end
      end
    end
  end
end
