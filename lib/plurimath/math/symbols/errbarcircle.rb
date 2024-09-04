module Plurimath
  module Math
    module Symbols
      class Errbarcircle < Symbol
        INPUT = {
          unicodemath: [["&#x29f2;"], parsing_wrapper(["errbarcircle"], lang: :unicode)],
          asciimath: [["&#x29f2;"], parsing_wrapper(["errbarcircle"], lang: :asciimath)],
          mathml: ["&#x29f2;"],
          latex: [["errbarcircle", "&#x29f2;"]],
          omml: ["&#x29f2;"],
          html: ["&#x29f2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\errbarcircle"
        end

        def to_asciimath(**)
          parsing_wrapper("errbarcircle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29f2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29f2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29f2;"
        end

        def to_html(**)
          "&#x29f2;"
        end
      end
    end
  end
end
