module Plurimath
  module Math
    module Symbols
      class Bumpeq < Symbol
        INPUT = {
          unicodemath: [["bumpeq", "&#x224f;"]],
          asciimath: [["&#x224f;"], parsing_wrapper(["bumpeq"], lang: :asciimath)],
          mathml: ["&#x224f;"],
          latex: [["bumpeq", "&#x224f;"]],
          omml: ["&#x224f;"],
          html: ["&#x224f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bumpeq"
        end

        def to_asciimath(**)
          parsing_wrapper("bumpeq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x224f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x224f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x224f;"
        end

        def to_html(**)
          "&#x224f;"
        end
      end
    end
  end
end
