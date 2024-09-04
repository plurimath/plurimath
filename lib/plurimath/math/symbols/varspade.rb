module Plurimath
  module Math
    module Symbols
      class Varspade < Symbol
        INPUT = {
          unicodemath: [["diamondsuit", "&#x2664;"], parsing_wrapper(["varspadesuit", "varspade"], lang: :unicode)],
          asciimath: [["&#x2664;"], parsing_wrapper(["diamondsuit", "varspadesuit", "varspade"], lang: :asciimath)],
          mathml: ["&#x2664;"],
          latex: [["varspadesuit", "varspade", "&#x2664;"], parsing_wrapper(["diamondsuit"], lang: :latex)],
          omml: ["&#x2664;"],
          html: ["&#x2664;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varspadesuit"
        end

        def to_asciimath(**)
          parsing_wrapper("varspade", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2664;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2664;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2664;"
        end

        def to_html(**)
          "&#x2664;"
        end
      end
    end
  end
end
