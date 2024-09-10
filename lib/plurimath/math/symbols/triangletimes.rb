module Plurimath
  module Math
    module Symbols
      class Triangletimes < Symbol
        INPUT = {
          unicodemath: [["&#x2a3b;"], parsing_wrapper(["triangletimes"], lang: :unicode)],
          asciimath: [["&#x2a3b;"], parsing_wrapper(["triangletimes"], lang: :asciimath)],
          mathml: ["&#x2a3b;"],
          latex: [["triangletimes", "&#x2a3b;"]],
          omml: ["&#x2a3b;"],
          html: ["&#x2a3b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\triangletimes"
        end

        def to_asciimath(**)
          parsing_wrapper("triangletimes", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a3b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a3b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a3b;"
        end

        def to_html(**)
          "&#x2a3b;"
        end
      end
    end
  end
end
