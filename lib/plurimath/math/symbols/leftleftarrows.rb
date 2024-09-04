module Plurimath
  module Math
    module Symbols
      class Leftleftarrows < Symbol
        INPUT = {
          unicodemath: [["leftleftarrows", "&#x21c7;"]],
          asciimath: [["&#x21c7;"], parsing_wrapper(["leftleftarrows"], lang: :asciimath)],
          mathml: ["&#x21c7;"],
          latex: [["leftleftarrows", "&#x21c7;"]],
          omml: ["&#x21c7;"],
          html: ["&#x21c7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftleftarrows"
        end

        def to_asciimath(**)
          parsing_wrapper("leftleftarrows", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21c7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21c7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21c7;"
        end

        def to_html(**)
          "&#x21c7;"
        end
      end
    end
  end
end
