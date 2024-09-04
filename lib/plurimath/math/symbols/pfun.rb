module Plurimath
  module Math
    module Symbols
      class Pfun < Symbol
        INPUT = {
          unicodemath: [["&#x21f8;"], parsing_wrapper(["nvrightarrow", "pfun"], lang: :unicode)],
          asciimath: [["&#x21f8;"], parsing_wrapper(["nvrightarrow", "pfun"], lang: :asciimath)],
          mathml: ["&#x21f8;"],
          latex: [["nvrightarrow", "pfun", "&#x21f8;"]],
          omml: ["&#x21f8;"],
          html: ["&#x21f8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nvrightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("pfun", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21f8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21f8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21f8;"
        end

        def to_html(**)
          "&#x21f8;"
        end
      end
    end
  end
end
