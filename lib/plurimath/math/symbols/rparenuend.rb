module Plurimath
  module Math
    module Symbols
      class Rparenuend < Symbol
        INPUT = {
          unicodemath: [["&#x239e;"], parsing_wrapper(["rparenuend"], lang: :unicode)],
          asciimath: [["&#x239e;"], parsing_wrapper(["rparenuend"], lang: :asciimath)],
          mathml: ["&#x239e;"],
          latex: [["rparenuend", "&#x239e;"]],
          omml: ["&#x239e;"],
          html: ["&#x239e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rparenuend"
        end

        def to_asciimath(**)
          parsing_wrapper("rparenuend", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x239e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x239e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x239e;"
        end

        def to_html(**)
          "&#x239e;"
        end
      end
    end
  end
end
