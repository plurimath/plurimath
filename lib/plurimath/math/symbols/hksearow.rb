module Plurimath
  module Math
    module Symbols
      class Hksearow < Symbol
        INPUT = {
          unicodemath: [["&#x2925;"], parsing_wrapper(["hksearow"], lang: :unicode)],
          asciimath: [["&#x2925;"], parsing_wrapper(["hksearow"], lang: :asciimath)],
          mathml: ["&#x2925;"],
          latex: [["hksearow", "&#x2925;"]],
          omml: ["&#x2925;"],
          html: ["&#x2925;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\hksearow"
        end

        def to_asciimath(**)
          parsing_wrapper("hksearow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2925;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2925;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2925;"
        end

        def to_html(**)
          "&#x2925;"
        end
      end
    end
  end
end
