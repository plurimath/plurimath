module Plurimath
  module Math
    module Symbols
      class Vrectangle < Symbol
        INPUT = {
          unicodemath: [["&#x25af;"], parsing_wrapper(["vrectangle"], lang: :unicode)],
          asciimath: [["&#x25af;"], parsing_wrapper(["vrectangle"], lang: :asciimath)],
          mathml: ["&#x25af;"],
          latex: [["vrectangle", "&#x25af;"]],
          omml: ["&#x25af;"],
          html: ["&#x25af;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\vrectangle"
        end

        def to_asciimath(**)
          parsing_wrapper("vrectangle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25af;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25af;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25af;"
        end

        def to_html(**)
          "&#x25af;"
        end
      end
    end
  end
end
