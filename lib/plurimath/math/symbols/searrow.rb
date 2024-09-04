module Plurimath
  module Math
    module Symbols
      class Searrow < Symbol
        INPUT = {
          unicodemath: [["&#x21d8;"], parsing_wrapper(["Searrow"], lang: :unicode)],
          asciimath: [["&#x21d8;"], parsing_wrapper(["Searrow"], lang: :asciimath)],
          mathml: ["&#x21d8;"],
          latex: [["Searrow", "&#x21d8;"]],
          omml: ["&#x21d8;"],
          html: ["&#x21d8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Searrow"
        end

        def to_asciimath(**)
          parsing_wrapper("Searrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21d8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21d8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21d8;"
        end

        def to_html(**)
          "&#x21d8;"
        end
      end
    end
  end
end
