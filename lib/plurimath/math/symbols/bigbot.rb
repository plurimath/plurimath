module Plurimath
  module Math
    module Symbols
      class Bigbot < Symbol
        INPUT = {
          unicodemath: [["&#x27d8;"], parsing_wrapper(["bigbot"], lang: :unicode)],
          asciimath: [["&#x27d8;"], parsing_wrapper(["bigbot"], lang: :asciimath)],
          mathml: ["&#x27d8;"],
          latex: [["bigbot", "&#x27d8;"]],
          omml: ["&#x27d8;"],
          html: ["&#x27d8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigbot"
        end

        def to_asciimath(**)
          parsing_wrapper("bigbot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27d8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27d8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27d8;"
        end

        def to_html(**)
          "&#x27d8;"
        end
      end
    end
  end
end
