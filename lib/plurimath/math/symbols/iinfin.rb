module Plurimath
  module Math
    module Symbols
      class Iinfin < Symbol
        INPUT = {
          unicodemath: [["&#x29dc;"], parsing_wrapper(["iinfin"], lang: :unicode)],
          asciimath: [["&#x29dc;"], parsing_wrapper(["iinfin"], lang: :asciimath)],
          mathml: ["&#x29dc;"],
          latex: [["iinfin", "&#x29dc;"]],
          omml: ["&#x29dc;"],
          html: ["&#x29dc;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\iinfin"
        end

        def to_asciimath(**)
          parsing_wrapper("iinfin", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29dc;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29dc;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29dc;"
        end

        def to_html(**)
          "&#x29dc;"
        end
      end
    end
  end
end
