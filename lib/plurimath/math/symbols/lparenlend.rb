module Plurimath
  module Math
    module Symbols
      class Lparenlend < Symbol
        INPUT = {
          unicodemath: [["&#x239d;"], parsing_wrapper(["lparenlend"], lang: :unicode)],
          asciimath: [["&#x239d;"], parsing_wrapper(["lparenlend"], lang: :asciimath)],
          mathml: ["&#x239d;"],
          latex: [["lparenlend", "&#x239d;"]],
          omml: ["&#x239d;"],
          html: ["&#x239d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lparenlend"
        end

        def to_asciimath(**)
          parsing_wrapper("lparenlend", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x239d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x239d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x239d;"
        end

        def to_html(**)
          "&#x239d;"
        end
      end
    end
  end
end
