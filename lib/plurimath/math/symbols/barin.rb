module Plurimath
  module Math
    module Symbols
      class Barin < Symbol
        INPUT = {
          unicodemath: [["&#x22f6;"], parsing_wrapper(["varisinobar", "barin"], lang: :unicode)],
          asciimath: [["&#x22f6;"], parsing_wrapper(["varisinobar", "barin"], lang: :asciimath)],
          mathml: ["&#x22f6;"],
          latex: [["varisinobar", "barin", "&#x22f6;"]],
          omml: ["&#x22f6;"],
          html: ["&#x22f6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varisinobar"
        end

        def to_asciimath(**)
          parsing_wrapper("barin", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22f6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22f6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22f6;"
        end

        def to_html(**)
          "&#x22f6;"
        end
      end
    end
  end
end
