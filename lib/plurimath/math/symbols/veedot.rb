module Plurimath
  module Math
    module Symbols
      class Veedot < Symbol
        INPUT = {
          unicodemath: [["&#x27c7;"], parsing_wrapper(["veedot"], lang: :unicode)],
          asciimath: [["&#x27c7;"], parsing_wrapper(["veedot"], lang: :asciimath)],
          mathml: ["&#x27c7;"],
          latex: [["veedot", "&#x27c7;"]],
          omml: ["&#x27c7;"],
          html: ["&#x27c7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\veedot"
        end

        def to_asciimath(**)
          parsing_wrapper("veedot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27c7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27c7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27c7;"
        end

        def to_html(**)
          "&#x27c7;"
        end
      end
    end
  end
end
