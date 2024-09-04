module Plurimath
  module Math
    module Symbols
      class Thermod < Symbol
        INPUT = {
          unicodemath: [["&#x29e7;"], parsing_wrapper(["thermod"], lang: :unicode)],
          asciimath: [["&#x29e7;"], parsing_wrapper(["thermod"], lang: :asciimath)],
          mathml: ["&#x29e7;"],
          latex: [["thermod", "&#x29e7;"]],
          omml: ["&#x29e7;"],
          html: ["&#x29e7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\thermod"
        end

        def to_asciimath(**)
          parsing_wrapper("thermod", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29e7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29e7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29e7;"
        end

        def to_html(**)
          "&#x29e7;"
        end
      end
    end
  end
end
