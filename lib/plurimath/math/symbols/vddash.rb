module Plurimath
  module Math
    module Symbols
      class Vddash < Symbol
        INPUT = {
          unicodemath: [["&#x2ae2;"], parsing_wrapper(["vDdash"], lang: :unicode)],
          asciimath: [["&#x2ae2;"], parsing_wrapper(["vDdash"], lang: :asciimath)],
          mathml: ["&#x2ae2;"],
          latex: [["vDdash", "&#x2ae2;"]],
          omml: ["&#x2ae2;"],
          html: ["&#x2ae2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\vDdash"
        end

        def to_asciimath(**)
          parsing_wrapper("vDdash", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ae2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ae2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ae2;"
        end

        def to_html(**)
          "&#x2ae2;"
        end
      end
    end
  end
end
