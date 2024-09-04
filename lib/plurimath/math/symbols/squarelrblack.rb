module Plurimath
  module Math
    module Symbols
      class Squarelrblack < Symbol
        INPUT = {
          unicodemath: [["&#x25ea;"], parsing_wrapper(["squarelrblack"], lang: :unicode)],
          asciimath: [["&#x25ea;"], parsing_wrapper(["squarelrblack"], lang: :asciimath)],
          mathml: ["&#x25ea;"],
          latex: [["squarelrblack", "&#x25ea;"]],
          omml: ["&#x25ea;"],
          html: ["&#x25ea;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\squarelrblack"
        end

        def to_asciimath(**)
          parsing_wrapper("squarelrblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25ea;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25ea;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25ea;"
        end

        def to_html(**)
          "&#x25ea;"
        end
      end
    end
  end
end
