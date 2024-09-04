module Plurimath
  module Math
    module Symbols
      class Lparenuend < Symbol
        INPUT = {
          unicodemath: [["&#x239b;"], parsing_wrapper(["lparenuend"], lang: :unicode)],
          asciimath: [["&#x239b;"], parsing_wrapper(["lparenuend"], lang: :asciimath)],
          mathml: ["&#x239b;"],
          latex: [["lparenuend", "&#x239b;"]],
          omml: ["&#x239b;"],
          html: ["&#x239b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lparenuend"
        end

        def to_asciimath(**)
          parsing_wrapper("lparenuend", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x239b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x239b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x239b;"
        end

        def to_html(**)
          "&#x239b;"
        end
      end
    end
  end
end
