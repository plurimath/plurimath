module Plurimath
  module Math
    module Symbols
      class Curlyvee < Symbol
        INPUT = {
          unicodemath: [["curlyvee", "&#x22ce;"]],
          asciimath: [["&#x22ce;"], parsing_wrapper(["curlyvee"], lang: :asciimath)],
          mathml: ["&#x22ce;"],
          latex: [["curlyvee", "&#x22ce;"]],
          omml: ["&#x22ce;"],
          html: ["&#x22ce;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\curlyvee"
        end

        def to_asciimath(**)
          parsing_wrapper("curlyvee", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22ce;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22ce;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22ce;"
        end

        def to_html(**)
          "&#x22ce;"
        end
      end
    end
  end
end
