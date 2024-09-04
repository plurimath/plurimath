module Plurimath
  module Math
    module Symbols
      class Saturn < Symbol
        INPUT = {
          unicodemath: [["&#x2644;"], parsing_wrapper(["saturn", "Saturn"], lang: :unicode)],
          asciimath: [["&#x2644;"], parsing_wrapper(["saturn", "Saturn"], lang: :asciimath)],
          mathml: ["&#x2644;"],
          latex: [["saturn", "Saturn", "&#x2644;"]],
          omml: ["&#x2644;"],
          html: ["&#x2644;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\saturn"
        end

        def to_asciimath(**)
          parsing_wrapper("Saturn", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2644;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2644;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2644;"
        end

        def to_html(**)
          "&#x2644;"
        end
      end
    end
  end
end
