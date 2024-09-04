module Plurimath
  module Math
    module Symbols
      class Rparenlend < Symbol
        INPUT = {
          unicodemath: [["&#x23a0;"], parsing_wrapper(["rparenlend"], lang: :unicode)],
          asciimath: [["&#x23a0;"], parsing_wrapper(["rparenlend"], lang: :asciimath)],
          mathml: ["&#x23a0;"],
          latex: [["rparenlend", "&#x23a0;"]],
          omml: ["&#x23a0;"],
          html: ["&#x23a0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rparenlend"
        end

        def to_asciimath(**)
          parsing_wrapper("rparenlend", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23a0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23a0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23a0;"
        end

        def to_html(**)
          "&#x23a0;"
        end
      end
    end
  end
end
