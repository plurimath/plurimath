module Plurimath
  module Math
    module Symbols
      class Nasymp < Symbol
        INPUT = {
          unicodemath: [["nasymp", "&#x226d;"], parsing_wrapper(["notasymp"], lang: :unicode)],
          asciimath: [["&#x226d;"], parsing_wrapper(["nasymp", "notasymp"], lang: :asciimath)],
          mathml: ["&#x226d;"],
          latex: [["notasymp", "nasymp", "&#x226d;"]],
          omml: ["&#x226d;"],
          html: ["&#x226d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\notasymp"
        end

        def to_asciimath(**)
          parsing_wrapper("nasymp", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x226d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x226d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x226d;"
        end

        def to_html(**)
          "&#x226d;"
        end
      end
    end
  end
end
