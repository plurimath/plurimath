module Plurimath
  module Math
    module Symbols
      class Smblksquare < Symbol
        INPUT = {
          unicodemath: [["&#x25aa;"], parsing_wrapper(["smblksquare"], lang: :unicode)],
          asciimath: [["&#x25aa;"], parsing_wrapper(["smblksquare"], lang: :asciimath)],
          mathml: ["&#x25aa;"],
          latex: [["smblksquare", "&#x25aa;"]],
          omml: ["&#x25aa;"],
          html: ["&#x25aa;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\smblksquare"
        end

        def to_asciimath(**)
          parsing_wrapper("smblksquare", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25aa;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25aa;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25aa;"
        end

        def to_html(**)
          "&#x25aa;"
        end
      end
    end
  end
end
