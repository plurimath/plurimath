module Plurimath
  module Math
    module Symbols
      class Im < Symbol
        INPUT = {
          unicodemath: [["Im", "&#x2111;"]],
          asciimath: [["&#x2111;"], parsing_wrapper(["Im"], lang: :asciimath)],
          mathml: ["&#x2111;"],
          latex: [["Im", "&#x2111;"]],
          omml: ["&#x2111;"],
          html: ["&#x2111;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Im"
        end

        def to_asciimath(**)
          parsing_wrapper("Im", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2111;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2111;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2111;"
        end

        def to_html(**)
          "&#x2111;"
        end
      end
    end
  end
end
