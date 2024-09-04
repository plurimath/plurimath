module Plurimath
  module Math
    module Symbols
      class Squareneswfill < Symbol
        INPUT = {
          unicodemath: [["&#x25a8;"], parsing_wrapper(["squareneswfill"], lang: :unicode)],
          asciimath: [["&#x25a8;"], parsing_wrapper(["squareneswfill"], lang: :asciimath)],
          mathml: ["&#x25a8;"],
          latex: [["squareneswfill", "&#x25a8;"]],
          omml: ["&#x25a8;"],
          html: ["&#x25a8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\squareneswfill"
        end

        def to_asciimath(**)
          parsing_wrapper("squareneswfill", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25a8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25a8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25a8;"
        end

        def to_html(**)
          "&#x25a8;"
        end
      end
    end
  end
end
