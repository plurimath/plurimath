module Plurimath
  module Math
    module Symbols
      class Vlongdash < Symbol
        INPUT = {
          unicodemath: [["&#x27dd;"], parsing_wrapper(["vlongdash"], lang: :unicode)],
          asciimath: [["&#x27dd;"], parsing_wrapper(["vlongdash"], lang: :asciimath)],
          mathml: ["&#x27dd;"],
          latex: [["vlongdash", "&#x27dd;"]],
          omml: ["&#x27dd;"],
          html: ["&#x27dd;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\vlongdash"
        end

        def to_asciimath(**)
          parsing_wrapper("vlongdash", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27dd;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27dd;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27dd;"
        end

        def to_html(**)
          "&#x27dd;"
        end
      end
    end
  end
end
