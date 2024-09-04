module Plurimath
  module Math
    module Symbols
      class Ngt < Symbol
        INPUT = {
          unicodemath: [["ngt", "&#x226f;"], parsing_wrapper(["ngtr"], lang: :unicode)],
          asciimath: [["&#x226f;"], parsing_wrapper(["ngt", "ngtr"], lang: :asciimath)],
          mathml: ["&#x226f;"],
          latex: [["ngtr", "&#x226f;"], parsing_wrapper(["ngt"], lang: :latex)],
          omml: ["&#x226f;"],
          html: ["&#x226f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ngtr"
        end

        def to_asciimath(**)
          parsing_wrapper("ngt", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x226f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x226f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x226f;"
        end

        def to_html(**)
          "&#x226f;"
        end
      end
    end
  end
end
