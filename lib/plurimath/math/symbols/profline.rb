module Plurimath
  module Math
    module Symbols
      class Profline < Symbol
        INPUT = {
          unicodemath: [["&#x2312;"], parsing_wrapper(["profline"], lang: :unicode)],
          asciimath: [["&#x2312;"], parsing_wrapper(["profline"], lang: :asciimath)],
          mathml: ["&#x2312;"],
          latex: [["profline", "&#x2312;"]],
          omml: ["&#x2312;"],
          html: ["&#x2312;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\profline"
        end

        def to_asciimath(**)
          parsing_wrapper("profline", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2312;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2312;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2312;"
        end

        def to_html(**)
          "&#x2312;"
        end
      end
    end
  end
end
