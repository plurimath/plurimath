module Plurimath
  module Math
    module Symbols
      class Sphat < Symbol
        INPUT = {
          unicodemath: [["&#x5e;"], parsing_wrapper(["sphat"], lang: :unicode)],
          asciimath: [["&#x5e;"], parsing_wrapper(["sphat"], lang: :asciimath)],
          mathml: ["&#x5e;"],
          latex: [["sphat", "&#x5e;"]],
          omml: ["&#x5e;"],
          html: ["&#x5e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sphat"
        end

        def to_asciimath(**)
          parsing_wrapper("sphat", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x5e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x5e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x5e;"
        end

        def to_html(**)
          "&#x5e;"
        end
      end
    end
  end
end
