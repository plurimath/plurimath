module Plurimath
  module Math
    module Symbols
      class Smallblacktriangleright < Symbol
        INPUT = {
          unicodemath: [["&#x25b8;"], parsing_wrapper(["smallblacktriangleright"], lang: :unicode)],
          asciimath: [["&#x25b8;"], parsing_wrapper(["smallblacktriangleright"], lang: :asciimath)],
          mathml: ["&#x25b8;"],
          latex: [["smallblacktriangleright", "&#x25b8;"]],
          omml: ["&#x25b8;"],
          html: ["&#x25b8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\smallblacktriangleright"
        end

        def to_asciimath(**)
          parsing_wrapper("smallblacktriangleright", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25b8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25b8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25b8;"
        end

        def to_html(**)
          "&#x25b8;"
        end
      end
    end
  end
end
