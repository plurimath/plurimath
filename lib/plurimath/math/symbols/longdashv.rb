module Plurimath
  module Math
    module Symbols
      class Longdashv < Symbol
        INPUT = {
          unicodemath: [["&#x27de;"], parsing_wrapper(["longdashv"], lang: :unicode)],
          asciimath: [["&#x27de;"], parsing_wrapper(["longdashv"], lang: :asciimath)],
          mathml: ["&#x27de;"],
          latex: [["longdashv", "&#x27de;"]],
          omml: ["&#x27de;"],
          html: ["&#x27de;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\longdashv"
        end

        def to_asciimath(**)
          parsing_wrapper("longdashv", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27de;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27de;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27de;"
        end

        def to_html(**)
          "&#x27de;"
        end
      end
    end
  end
end
