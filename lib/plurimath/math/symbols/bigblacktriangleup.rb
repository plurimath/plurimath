module Plurimath
  module Math
    module Symbols
      class Bigblacktriangleup < Symbol
        INPUT = {
          unicodemath: [["&#x25b2;"], parsing_wrapper(["bigblacktriangleup"], lang: :unicode)],
          asciimath: [["&#x25b2;"], parsing_wrapper(["bigblacktriangleup"], lang: :asciimath)],
          mathml: ["&#x25b2;"],
          latex: [["bigblacktriangleup", "&#x25b2;"]],
          omml: ["&#x25b2;"],
          html: ["&#x25b2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigblacktriangleup"
        end

        def to_asciimath(**)
          parsing_wrapper("bigblacktriangleup", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25b2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25b2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25b2;"
        end

        def to_html(**)
          "&#x25b2;"
        end
      end
    end
  end
end
