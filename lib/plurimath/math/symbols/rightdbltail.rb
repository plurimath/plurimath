module Plurimath
  module Math
    module Symbols
      class Rightdbltail < Symbol
        INPUT = {
          unicodemath: [["&#x291c;"], parsing_wrapper(["rightdbltail"], lang: :unicode)],
          asciimath: [["&#x291c;"], parsing_wrapper(["rightdbltail"], lang: :asciimath)],
          mathml: ["&#x291c;"],
          latex: [["rightdbltail", "&#x291c;"]],
          omml: ["&#x291c;"],
          html: ["&#x291c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightdbltail"
        end

        def to_asciimath(**)
          parsing_wrapper("rightdbltail", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x291c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x291c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x291c;"
        end

        def to_html(**)
          "&#x291c;"
        end
      end
    end
  end
end
