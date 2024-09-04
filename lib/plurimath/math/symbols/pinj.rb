module Plurimath
  module Math
    module Symbols
      class Pinj < Symbol
        INPUT = {
          unicodemath: [["&#x2914;"], parsing_wrapper(["nvrightarrowtail", "pinj"], lang: :unicode)],
          asciimath: [["&#x2914;"], parsing_wrapper(["nvrightarrowtail", "pinj"], lang: :asciimath)],
          mathml: ["&#x2914;"],
          latex: [["nvrightarrowtail", "pinj", "&#x2914;"]],
          omml: ["&#x2914;"],
          html: ["&#x2914;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nvrightarrowtail"
        end

        def to_asciimath(**)
          parsing_wrapper("pinj", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2914;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2914;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2914;"
        end

        def to_html(**)
          "&#x2914;"
        end
      end
    end
  end
end
