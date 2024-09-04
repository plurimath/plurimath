module Plurimath
  module Math
    module Symbols
      class Lbracelend < Symbol
        INPUT = {
          unicodemath: [["&#x23a9;"], parsing_wrapper(["lbracelend"], lang: :unicode)],
          asciimath: [["&#x23a9;"], parsing_wrapper(["lbracelend"], lang: :asciimath)],
          mathml: ["&#x23a9;"],
          latex: [["lbracelend", "&#x23a9;"]],
          omml: ["&#x23a9;"],
          html: ["&#x23a9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lbracelend"
        end

        def to_asciimath(**)
          parsing_wrapper("lbracelend", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23a9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23a9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23a9;"
        end

        def to_html(**)
          "&#x23a9;"
        end
      end
    end
  end
end
