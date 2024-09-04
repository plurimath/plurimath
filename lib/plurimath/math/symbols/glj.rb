module Plurimath
  module Math
    module Symbols
      class Glj < Symbol
        INPUT = {
          unicodemath: [["&#x2aa4;"], parsing_wrapper(["glj"], lang: :unicode)],
          asciimath: [["&#x2aa4;"], parsing_wrapper(["glj"], lang: :asciimath)],
          mathml: ["&#x2aa4;"],
          latex: [["glj", "&#x2aa4;"]],
          omml: ["&#x2aa4;"],
          html: ["&#x2aa4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\glj"
        end

        def to_asciimath(**)
          parsing_wrapper("glj", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2aa4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2aa4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2aa4;"
        end

        def to_html(**)
          "&#x2aa4;"
        end
      end
    end
  end
end
