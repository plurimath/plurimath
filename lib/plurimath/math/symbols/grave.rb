module Plurimath
  module Math
    module Symbols
      class Grave < Symbol
        INPUT = {
          unicodemath: [["&#x300;"], parsing_wrapper(["grave"], lang: :unicode)],
          asciimath: [["&#x300;"], parsing_wrapper(["grave"], lang: :asciimath)],
          mathml: ["&#x300;"],
          latex: [["grave", "&#x300;"]],
          omml: ["&#x300;"],
          html: ["&#x300;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\grave"
        end

        def to_asciimath(**)
          parsing_wrapper("grave", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x300;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x300;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x300;"
        end

        def to_html(**)
          "&#x300;"
        end
      end
    end
  end
end
