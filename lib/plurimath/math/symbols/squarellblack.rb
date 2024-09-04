module Plurimath
  module Math
    module Symbols
      class Squarellblack < Symbol
        INPUT = {
          unicodemath: [["&#x2b15;"], parsing_wrapper(["squarellblack"], lang: :unicode)],
          asciimath: [["&#x2b15;"], parsing_wrapper(["squarellblack"], lang: :asciimath)],
          mathml: ["&#x2b15;"],
          latex: [["squarellblack", "&#x2b15;"]],
          omml: ["&#x2b15;"],
          html: ["&#x2b15;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\squarellblack"
        end

        def to_asciimath(**)
          parsing_wrapper("squarellblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b15;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b15;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b15;"
        end

        def to_html(**)
          "&#x2b15;"
        end
      end
    end
  end
end
