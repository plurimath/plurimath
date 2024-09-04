module Plurimath
  module Math
    module Symbols
      class Squarerightblack < Symbol
        INPUT = {
          unicodemath: [["&#x25e8;"], parsing_wrapper(["squarerightblack"], lang: :unicode)],
          asciimath: [["&#x25e8;"], parsing_wrapper(["squarerightblack"], lang: :asciimath)],
          mathml: ["&#x25e8;"],
          latex: [["squarerightblack", "&#x25e8;"]],
          omml: ["&#x25e8;"],
          html: ["&#x25e8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\squarerightblack"
        end

        def to_asciimath(**)
          parsing_wrapper("squarerightblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25e8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25e8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25e8;"
        end

        def to_html(**)
          "&#x25e8;"
        end
      end
    end
  end
end
