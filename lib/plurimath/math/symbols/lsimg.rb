module Plurimath
  module Math
    module Symbols
      class Lsimg < Symbol
        INPUT = {
          unicodemath: [["&#x2a8f;"], parsing_wrapper(["lsimg"], lang: :unicode)],
          asciimath: [["&#x2a8f;"], parsing_wrapper(["lsimg"], lang: :asciimath)],
          mathml: ["&#x2a8f;"],
          latex: [["lsimg", "&#x2a8f;"]],
          omml: ["&#x2a8f;"],
          html: ["&#x2a8f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lsimg"
        end

        def to_asciimath(**)
          parsing_wrapper("lsimg", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a8f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a8f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a8f;"
        end

        def to_html(**)
          "&#x2a8f;"
        end
      end
    end
  end
end
