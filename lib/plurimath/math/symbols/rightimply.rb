module Plurimath
  module Math
    module Symbols
      class Rightimply < Symbol
        INPUT = {
          unicodemath: [["&#x2970;"], parsing_wrapper(["rightimply"], lang: :unicode)],
          asciimath: [["&#x2970;"], parsing_wrapper(["rightimply"], lang: :asciimath)],
          mathml: ["&#x2970;"],
          latex: [["rightimply", "&#x2970;"]],
          omml: ["&#x2970;"],
          html: ["&#x2970;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightimply"
        end

        def to_asciimath(**)
          parsing_wrapper("rightimply", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2970;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2970;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2970;"
        end

        def to_html(**)
          "&#x2970;"
        end
      end
    end
  end
end
