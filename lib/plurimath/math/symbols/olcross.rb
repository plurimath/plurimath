module Plurimath
  module Math
    module Symbols
      class Olcross < Symbol
        INPUT = {
          unicodemath: [["&#x29bb;"], parsing_wrapper(["olcross"], lang: :unicode)],
          asciimath: [["&#x29bb;"], parsing_wrapper(["olcross"], lang: :asciimath)],
          mathml: ["&#x29bb;"],
          latex: [["olcross", "&#x29bb;"]],
          omml: ["&#x29bb;"],
          html: ["&#x29bb;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\olcross"
        end

        def to_asciimath(**)
          parsing_wrapper("olcross", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29bb;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29bb;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29bb;"
        end

        def to_html(**)
          "&#x29bb;"
        end
      end
    end
  end
end
