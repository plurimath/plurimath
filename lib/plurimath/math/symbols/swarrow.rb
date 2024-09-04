module Plurimath
  module Math
    module Symbols
      class Swarrow < Symbol
        INPUT = {
          unicodemath: [["&#x21d9;"], parsing_wrapper(["Swarrow"], lang: :unicode)],
          asciimath: [["&#x21d9;"], parsing_wrapper(["Swarrow"], lang: :asciimath)],
          mathml: ["&#x21d9;"],
          latex: [["Swarrow", "&#x21d9;"]],
          omml: ["&#x21d9;"],
          html: ["&#x21d9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Swarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("Swarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21d9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21d9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21d9;"
        end

        def to_html(**)
          "&#x21d9;"
        end
      end
    end
  end
end
