module Plurimath
  module Math
    module Symbols
      class Leftdbltail < Symbol
        INPUT = {
          unicodemath: [["&#x291b;"], parsing_wrapper(["leftdbltail"], lang: :unicode)],
          asciimath: [["&#x291b;"], parsing_wrapper(["leftdbltail"], lang: :asciimath)],
          mathml: ["&#x291b;"],
          latex: [["leftdbltail", "&#x291b;"]],
          omml: ["&#x291b;"],
          html: ["&#x291b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftdbltail"
        end

        def to_asciimath(**)
          parsing_wrapper("leftdbltail", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x291b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x291b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x291b;"
        end

        def to_html(**)
          "&#x291b;"
        end
      end
    end
  end
end
