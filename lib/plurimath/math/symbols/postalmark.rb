module Plurimath
  module Math
    module Symbols
      class Postalmark < Symbol
        INPUT = {
          unicodemath: [["&#x3012;"], parsing_wrapper(["postalmark"], lang: :unicode)],
          asciimath: [["&#x3012;"], parsing_wrapper(["postalmark"], lang: :asciimath)],
          mathml: ["&#x3012;"],
          latex: [["postalmark", "&#x3012;"]],
          omml: ["&#x3012;"],
          html: ["&#x3012;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\postalmark"
        end

        def to_asciimath(**)
          parsing_wrapper("postalmark", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3012;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3012;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3012;"
        end

        def to_html(**)
          "&#x3012;"
        end
      end
    end
  end
end
