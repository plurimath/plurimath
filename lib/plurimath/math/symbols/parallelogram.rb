module Plurimath
  module Math
    module Symbols
      class Parallelogram < Symbol
        INPUT = {
          unicodemath: [["&#x25b1;"], parsing_wrapper(["parallelogram"], lang: :unicode)],
          asciimath: [["&#x25b1;"], parsing_wrapper(["parallelogram"], lang: :asciimath)],
          mathml: ["&#x25b1;"],
          latex: [["parallelogram", "&#x25b1;"]],
          omml: ["&#x25b1;"],
          html: ["&#x25b1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\parallelogram"
        end

        def to_asciimath(**)
          parsing_wrapper("parallelogram", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25b1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25b1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25b1;"
        end

        def to_html(**)
          "&#x25b1;"
        end
      end
    end
  end
end
