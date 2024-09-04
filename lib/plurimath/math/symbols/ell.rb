module Plurimath
  module Math
    module Symbols
      class Ell < Symbol
        INPUT = {
          unicodemath: [["ell", "&#x2113;"]],
          asciimath: [["&#x2113;"], parsing_wrapper(["ell"], lang: :asciimath)],
          mathml: ["&#x2113;"],
          latex: [["ell", "&#x2113;"]],
          omml: ["&#x2113;"],
          html: ["&#x2113;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ell"
        end

        def to_asciimath(**)
          parsing_wrapper("ell", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2113;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2113;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2113;"
        end

        def to_html(**)
          "&#x2113;"
        end
      end
    end
  end
end
