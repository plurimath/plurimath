module Plurimath
  module Math
    module Symbols
      class Lrtriangle < Symbol
        INPUT = {
          unicodemath: [["&#x25ff;"], parsing_wrapper(["lrtriangle"], lang: :unicode)],
          asciimath: [["&#x25ff;"], parsing_wrapper(["lrtriangle"], lang: :asciimath)],
          mathml: ["&#x25ff;"],
          latex: [["lrtriangle", "&#x25ff;"]],
          omml: ["&#x25ff;"],
          html: ["&#x25ff;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lrtriangle"
        end

        def to_asciimath(**)
          parsing_wrapper("lrtriangle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25ff;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25ff;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25ff;"
        end

        def to_html(**)
          "&#x25ff;"
        end
      end
    end
  end
end
