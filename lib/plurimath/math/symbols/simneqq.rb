module Plurimath
  module Math
    module Symbols
      class Simneqq < Symbol
        INPUT = {
          unicodemath: [["&#x2246;"], parsing_wrapper(["simneqq"], lang: :unicode)],
          asciimath: [["&#x2246;"], parsing_wrapper(["simneqq"], lang: :asciimath)],
          mathml: ["&#x2246;"],
          latex: [["simneqq", "&#x2246;"]],
          omml: ["&#x2246;"],
          html: ["&#x2246;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\simneqq"
        end

        def to_asciimath(**)
          parsing_wrapper("simneqq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2246;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2246;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2246;"
        end

        def to_html(**)
          "&#x2246;"
        end
      end
    end
  end
end
