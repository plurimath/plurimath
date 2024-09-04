module Plurimath
  module Math
    module Symbols
      class Rblkbrbrak < Symbol
        INPUT = {
          unicodemath: [["&#x2998;"], parsing_wrapper(["rblkbrbrak"], lang: :unicode)],
          asciimath: [["&#x2998;"], parsing_wrapper(["rblkbrbrak"], lang: :asciimath)],
          mathml: ["&#x2998;"],
          latex: [["rblkbrbrak", "&#x2998;"]],
          omml: ["&#x2998;"],
          html: ["&#x2998;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rblkbrbrak"
        end

        def to_asciimath(**)
          parsing_wrapper("rblkbrbrak", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2998;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2998;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2998;"
        end

        def to_html(**)
          "&#x2998;"
        end
      end
    end
  end
end
