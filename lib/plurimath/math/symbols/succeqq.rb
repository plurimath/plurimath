module Plurimath
  module Math
    module Symbols
      class Succeqq < Symbol
        INPUT = {
          unicodemath: [["&#x2ab4;"], parsing_wrapper(["succeqq"], lang: :unicode)],
          asciimath: [["&#x2ab4;"], parsing_wrapper(["succeqq"], lang: :asciimath)],
          mathml: ["&#x2ab4;"],
          latex: [["succeqq", "&#x2ab4;"]],
          omml: ["&#x2ab4;"],
          html: ["&#x2ab4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\succeqq"
        end

        def to_asciimath(**)
          parsing_wrapper("succeqq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ab4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ab4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ab4;"
        end

        def to_html(**)
          "&#x2ab4;"
        end
      end
    end
  end
end
