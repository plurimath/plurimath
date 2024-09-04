module Plurimath
  module Math
    module Symbols
      class Leftrightharpoonsup < Symbol
        INPUT = {
          unicodemath: [["&#x2966;"], parsing_wrapper(["leftrightharpoonsup"], lang: :unicode)],
          asciimath: [["&#x2966;"], parsing_wrapper(["leftrightharpoonsup"], lang: :asciimath)],
          mathml: ["&#x2966;"],
          latex: [["leftrightharpoonsup", "&#x2966;"]],
          omml: ["&#x2966;"],
          html: ["&#x2966;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftrightharpoonsup"
        end

        def to_asciimath(**)
          parsing_wrapper("leftrightharpoonsup", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2966;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2966;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2966;"
        end

        def to_html(**)
          "&#x2966;"
        end
      end
    end
  end
end
