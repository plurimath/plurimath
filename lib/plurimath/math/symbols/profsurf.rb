module Plurimath
  module Math
    module Symbols
      class Profsurf < Symbol
        INPUT = {
          unicodemath: [["&#x2313;"], parsing_wrapper(["profsurf"], lang: :unicode)],
          asciimath: [["&#x2313;"], parsing_wrapper(["profsurf"], lang: :asciimath)],
          mathml: ["&#x2313;"],
          latex: [["profsurf", "&#x2313;"]],
          omml: ["&#x2313;"],
          html: ["&#x2313;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\profsurf"
        end

        def to_asciimath(**)
          parsing_wrapper("profsurf", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2313;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2313;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2313;"
        end

        def to_html(**)
          "&#x2313;"
        end
      end
    end
  end
end
