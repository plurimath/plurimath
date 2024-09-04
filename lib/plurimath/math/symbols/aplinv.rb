module Plurimath
  module Math
    module Symbols
      class Aplinv < Symbol
        INPUT = {
          unicodemath: [["&#x2339;"], parsing_wrapper(["APLinv"], lang: :unicode)],
          asciimath: [["&#x2339;"], parsing_wrapper(["APLinv"], lang: :asciimath)],
          mathml: ["&#x2339;"],
          latex: [["APLinv", "&#x2339;"]],
          omml: ["&#x2339;"],
          html: ["&#x2339;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\APLinv"
        end

        def to_asciimath(**)
          parsing_wrapper("APLinv", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2339;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2339;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2339;"
        end

        def to_html(**)
          "&#x2339;"
        end
      end
    end
  end
end
