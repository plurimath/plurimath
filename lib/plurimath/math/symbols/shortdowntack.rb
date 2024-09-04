module Plurimath
  module Math
    module Symbols
      class Shortdowntack < Symbol
        INPUT = {
          unicodemath: [["&#x2adf;"], parsing_wrapper(["shortdowntack"], lang: :unicode)],
          asciimath: [["&#x2adf;"], parsing_wrapper(["shortdowntack"], lang: :asciimath)],
          mathml: ["&#x2adf;"],
          latex: [["shortdowntack", "&#x2adf;"]],
          omml: ["&#x2adf;"],
          html: ["&#x2adf;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\shortdowntack"
        end

        def to_asciimath(**)
          parsing_wrapper("shortdowntack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2adf;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2adf;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2adf;"
        end

        def to_html(**)
          "&#x2adf;"
        end
      end
    end
  end
end
