module Plurimath
  module Math
    module Symbols
      class Obar < Symbol
        INPUT = {
          unicodemath: [["&#x233d;"], parsing_wrapper(["obar"], lang: :unicode)],
          asciimath: [["&#x233d;"], parsing_wrapper(["obar"], lang: :asciimath)],
          mathml: ["&#x233d;"],
          latex: [["obar", "&#x233d;"]],
          omml: ["&#x233d;"],
          html: ["&#x233d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\obar"
        end

        def to_asciimath(**)
          parsing_wrapper("obar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x233d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x233d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x233d;"
        end

        def to_html(**)
          "&#x233d;"
        end
      end
    end
  end
end
