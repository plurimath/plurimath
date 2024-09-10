module Plurimath
  module Math
    module Symbols
      class Underparen < Symbol
        INPUT = {
          unicodemath: [["&#x23dd;"], parsing_wrapper(["underparen"], lang: :unicode)],
          asciimath: [["&#x23dd;"], parsing_wrapper(["underparen"], lang: :asciimath)],
          mathml: ["&#x23dd;"],
          latex: [["underparen", "&#x23dd;"]],
          omml: ["&#x23dd;"],
          html: ["&#x23dd;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\underparen"
        end

        def to_asciimath(**)
          parsing_wrapper("underparen", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23dd;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23dd;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23dd;"
        end

        def to_html(**)
          "&#x23dd;"
        end
      end
    end
  end
end
