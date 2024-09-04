module Plurimath
  module Math
    module Symbols
      class Shortrightarrowleftarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2944;"], parsing_wrapper(["shortrightarrowleftarrow"], lang: :unicode)],
          asciimath: [["&#x2944;"], parsing_wrapper(["shortrightarrowleftarrow"], lang: :asciimath)],
          mathml: ["&#x2944;"],
          latex: [["shortrightarrowleftarrow", "&#x2944;"]],
          omml: ["&#x2944;"],
          html: ["&#x2944;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\shortrightarrowleftarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("shortrightarrowleftarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2944;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2944;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2944;"
        end

        def to_html(**)
          "&#x2944;"
        end
      end
    end
  end
end
