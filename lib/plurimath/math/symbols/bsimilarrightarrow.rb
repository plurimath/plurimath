module Plurimath
  module Math
    module Symbols
      class Bsimilarrightarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2b47;"], parsing_wrapper(["bsimilarrightarrow"], lang: :unicode)],
          asciimath: [["&#x2b47;"], parsing_wrapper(["bsimilarrightarrow"], lang: :asciimath)],
          mathml: ["&#x2b47;"],
          latex: [["bsimilarrightarrow", "&#x2b47;"]],
          omml: ["&#x2b47;"],
          html: ["&#x2b47;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bsimilarrightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("bsimilarrightarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b47;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b47;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b47;"
        end

        def to_html(**)
          "&#x2b47;"
        end
      end
    end
  end
end
