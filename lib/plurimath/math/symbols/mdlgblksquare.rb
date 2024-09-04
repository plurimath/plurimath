module Plurimath
  module Math
    module Symbols
      class Mdlgblksquare < Symbol
        INPUT = {
          unicodemath: [["&#x25a0;"], parsing_wrapper(["mdlgblksquare"], lang: :unicode)],
          asciimath: [["&#x25a0;"], parsing_wrapper(["mdlgblksquare"], lang: :asciimath)],
          mathml: ["&#x25a0;"],
          latex: [["mdlgblksquare", "&#x25a0;"]],
          omml: ["&#x25a0;"],
          html: ["&#x25a0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mdlgblksquare"
        end

        def to_asciimath(**)
          parsing_wrapper("mdlgblksquare", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25a0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25a0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25a0;"
        end

        def to_html(**)
          "&#x25a0;"
        end
      end
    end
  end
end
