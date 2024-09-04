module Plurimath
  module Math
    module Symbols
      class Downtrianglerightblack < Symbol
        INPUT = {
          unicodemath: [["&#x29e9;"], parsing_wrapper(["downtrianglerightblack"], lang: :unicode)],
          asciimath: [["&#x29e9;"], parsing_wrapper(["downtrianglerightblack"], lang: :asciimath)],
          mathml: ["&#x29e9;"],
          latex: [["downtrianglerightblack", "&#x29e9;"]],
          omml: ["&#x29e9;"],
          html: ["&#x29e9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\downtrianglerightblack"
        end

        def to_asciimath(**)
          parsing_wrapper("downtrianglerightblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29e9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29e9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29e9;"
        end

        def to_html(**)
          "&#x29e9;"
        end
      end
    end
  end
end
