module Plurimath
  module Math
    module Symbols
      class Rbracemid < Symbol
        INPUT = {
          unicodemath: [["&#x23ac;"], parsing_wrapper(["rbracemid"], lang: :unicode)],
          asciimath: [["&#x23ac;"], parsing_wrapper(["rbracemid"], lang: :asciimath)],
          mathml: ["&#x23ac;"],
          latex: [["rbracemid", "&#x23ac;"]],
          omml: ["&#x23ac;"],
          html: ["&#x23ac;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rbracemid"
        end

        def to_asciimath(**)
          parsing_wrapper("rbracemid", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23ac;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23ac;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23ac;"
        end

        def to_html(**)
          "&#x23ac;"
        end
      end
    end
  end
end
