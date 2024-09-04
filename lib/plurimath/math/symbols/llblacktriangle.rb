module Plurimath
  module Math
    module Symbols
      class Llblacktriangle < Symbol
        INPUT = {
          unicodemath: [["&#x25e3;"], parsing_wrapper(["llblacktriangle"], lang: :unicode)],
          asciimath: [["&#x25e3;"], parsing_wrapper(["llblacktriangle"], lang: :asciimath)],
          mathml: ["&#x25e3;"],
          latex: [["llblacktriangle", "&#x25e3;"]],
          omml: ["&#x25e3;"],
          html: ["&#x25e3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\llblacktriangle"
        end

        def to_asciimath(**)
          parsing_wrapper("llblacktriangle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25e3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25e3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25e3;"
        end

        def to_html(**)
          "&#x25e3;"
        end
      end
    end
  end
end
