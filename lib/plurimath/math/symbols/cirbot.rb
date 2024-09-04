module Plurimath
  module Math
    module Symbols
      class Cirbot < Symbol
        INPUT = {
          unicodemath: [["&#x27df;"], parsing_wrapper(["cirbot"], lang: :unicode)],
          asciimath: [["&#x27df;"], parsing_wrapper(["cirbot"], lang: :asciimath)],
          mathml: ["&#x27df;"],
          latex: [["cirbot", "&#x27df;"]],
          omml: ["&#x27df;"],
          html: ["&#x27df;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\cirbot"
        end

        def to_asciimath(**)
          parsing_wrapper("cirbot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27df;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27df;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27df;"
        end

        def to_html(**)
          "&#x27df;"
        end
      end
    end
  end
end
