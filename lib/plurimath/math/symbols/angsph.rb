module Plurimath
  module Math
    module Symbols
      class Angsph < Symbol
        INPUT = {
          unicodemath: [["angsph", "&#x2222;"], parsing_wrapper(["sphericalangle"], lang: :unicode)],
          asciimath: [["&#x2222;"], parsing_wrapper(["angsph", "sphericalangle"], lang: :asciimath)],
          mathml: ["&#x2222;"],
          latex: [["sphericalangle", "&#x2222;"], parsing_wrapper(["angsph"], lang: :latex)],
          omml: ["&#x2222;"],
          html: ["&#x2222;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sphericalangle"
        end

        def to_asciimath(**)
          parsing_wrapper("angsph", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2222;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2222;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2222;"
        end

        def to_html(**)
          "&#x2222;"
        end
      end
    end
  end
end
