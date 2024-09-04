module Plurimath
  module Math
    module Symbols
      class Lesdotor < Symbol
        INPUT = {
          unicodemath: [["&#x2a83;"], parsing_wrapper(["lesdotor"], lang: :unicode)],
          asciimath: [["&#x2a83;"], parsing_wrapper(["lesdotor"], lang: :asciimath)],
          mathml: ["&#x2a83;"],
          latex: [["lesdotor", "&#x2a83;"]],
          omml: ["&#x2a83;"],
          html: ["&#x2a83;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lesdotor"
        end

        def to_asciimath(**)
          parsing_wrapper("lesdotor", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a83;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a83;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a83;"
        end

        def to_html(**)
          "&#x2a83;"
        end
      end
    end
  end
end
