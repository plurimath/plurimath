module Plurimath
  module Math
    module Symbols
      class Pisces < Symbol
        INPUT = {
          unicodemath: [["&#x2653;"], parsing_wrapper(["pisces"], lang: :unicode)],
          asciimath: [["&#x2653;"], parsing_wrapper(["pisces"], lang: :asciimath)],
          mathml: ["&#x2653;"],
          latex: [["pisces", "&#x2653;"]],
          omml: ["&#x2653;"],
          html: ["&#x2653;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\pisces"
        end

        def to_asciimath(**)
          parsing_wrapper("pisces", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2653;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2653;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2653;"
        end

        def to_html(**)
          "&#x2653;"
        end
      end
    end
  end
end
