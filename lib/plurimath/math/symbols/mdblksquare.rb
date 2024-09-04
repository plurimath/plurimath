module Plurimath
  module Math
    module Symbols
      class Mdblksquare < Symbol
        INPUT = {
          unicodemath: [["&#x25fc;"], parsing_wrapper(["blacksquare", "mdblksquare"], lang: :unicode)],
          asciimath: [["&#x25fc;"], parsing_wrapper(["blacksquare", "mdblksquare"], lang: :asciimath)],
          mathml: ["&#x25fc;"],
          latex: [["blacksquare", "mdblksquare", "&#x25fc;"]],
          omml: ["&#x25fc;"],
          html: ["&#x25fc;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blacksquare"
        end

        def to_asciimath(**)
          parsing_wrapper("mdblksquare", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25fc;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25fc;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25fc;"
        end

        def to_html(**)
          "&#x25fc;"
        end
      end
    end
  end
end
