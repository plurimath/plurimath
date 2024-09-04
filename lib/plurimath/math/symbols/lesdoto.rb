module Plurimath
  module Math
    module Symbols
      class Lesdoto < Symbol
        INPUT = {
          unicodemath: [["&#x2a81;"], parsing_wrapper(["lesdoto"], lang: :unicode)],
          asciimath: [["&#x2a81;"], parsing_wrapper(["lesdoto"], lang: :asciimath)],
          mathml: ["&#x2a81;"],
          latex: [["lesdoto", "&#x2a81;"]],
          omml: ["&#x2a81;"],
          html: ["&#x2a81;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lesdoto"
        end

        def to_asciimath(**)
          parsing_wrapper("lesdoto", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a81;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a81;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a81;"
        end

        def to_html(**)
          "&#x2a81;"
        end
      end
    end
  end
end
