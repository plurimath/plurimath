module Plurimath
  module Math
    module Symbols
      class Rightbkarrow < Symbol
        INPUT = {
          unicodemath: [["&#x290d;"], parsing_wrapper(["rightbkarrow"], lang: :unicode)],
          asciimath: [["&#x290d;"], parsing_wrapper(["rightbkarrow"], lang: :asciimath)],
          mathml: ["&#x290d;"],
          latex: [["rightbkarrow", "&#x290d;"]],
          omml: ["&#x290d;"],
          html: ["&#x290d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightbkarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("rightbkarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x290d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x290d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x290d;"
        end

        def to_html(**)
          "&#x290d;"
        end
      end
    end
  end
end
