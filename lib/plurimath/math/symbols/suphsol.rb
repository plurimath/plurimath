module Plurimath
  module Math
    module Symbols
      class Suphsol < Symbol
        INPUT = {
          unicodemath: [["&#x27c9;"], parsing_wrapper(["suphsol"], lang: :unicode)],
          asciimath: [["&#x27c9;"], parsing_wrapper(["suphsol"], lang: :asciimath)],
          mathml: ["&#x27c9;"],
          latex: [["suphsol", "&#x27c9;"]],
          omml: ["&#x27c9;"],
          html: ["&#x27c9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\suphsol"
        end

        def to_asciimath(**)
          parsing_wrapper("suphsol", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27c9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27c9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27c9;"
        end

        def to_html(**)
          "&#x27c9;"
        end
      end
    end
  end
end
