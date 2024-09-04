module Plurimath
  module Math
    module Symbols
      class Parallelogramblack < Symbol
        INPUT = {
          unicodemath: [["&#x25b0;"], parsing_wrapper(["parallelogramblack"], lang: :unicode)],
          asciimath: [["&#x25b0;"], parsing_wrapper(["parallelogramblack"], lang: :asciimath)],
          mathml: ["&#x25b0;"],
          latex: [["parallelogramblack", "&#x25b0;"]],
          omml: ["&#x25b0;"],
          html: ["&#x25b0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\parallelogramblack"
        end

        def to_asciimath(**)
          parsing_wrapper("parallelogramblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25b0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25b0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25b0;"
        end

        def to_html(**)
          "&#x25b0;"
        end
      end
    end
  end
end
