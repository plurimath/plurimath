module Plurimath
  module Math
    module Symbols
      class Uparrow < Symbol
        INPUT = {
          unicodemath: [["Uparrow", "&#x21d1;"]],
          asciimath: [["&#x21d1;"], parsing_wrapper(["Uparrow"], lang: :asciimath)],
          mathml: ["&#x21d1;"],
          latex: [["Uparrow", "&#x21d1;"]],
          omml: ["&#x21d1;"],
          html: ["&#x21d1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Uparrow"
        end

        def to_asciimath(**)
          parsing_wrapper("Uparrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21d1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21d1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21d1;"
        end

        def to_html(**)
          "&#x21d1;"
        end
      end
    end
  end
end
