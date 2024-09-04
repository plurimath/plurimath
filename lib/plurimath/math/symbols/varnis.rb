module Plurimath
  module Math
    module Symbols
      class Varnis < Symbol
        INPUT = {
          unicodemath: [["&#x22fb;"], parsing_wrapper(["varnis"], lang: :unicode)],
          asciimath: [["&#x22fb;"], parsing_wrapper(["varnis"], lang: :asciimath)],
          mathml: ["&#x22fb;"],
          latex: [["varnis", "&#x22fb;"]],
          omml: ["&#x22fb;"],
          html: ["&#x22fb;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varnis"
        end

        def to_asciimath(**)
          parsing_wrapper("varnis", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22fb;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22fb;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22fb;"
        end

        def to_html(**)
          "&#x22fb;"
        end
      end
    end
  end
end
