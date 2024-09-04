module Plurimath
  module Math
    module Symbols
      class Uuparrow < Symbol
        INPUT = {
          unicodemath: [["&#x290a;"], parsing_wrapper(["Uuparrow"], lang: :unicode)],
          asciimath: [["&#x290a;"], parsing_wrapper(["Uuparrow"], lang: :asciimath)],
          mathml: ["&#x290a;"],
          latex: [["Uuparrow", "&#x290a;"]],
          omml: ["&#x290a;"],
          html: ["&#x290a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Uuparrow"
        end

        def to_asciimath(**)
          parsing_wrapper("Uuparrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x290a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x290a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x290a;"
        end

        def to_html(**)
          "&#x290a;"
        end
      end
    end
  end
end
