module Plurimath
  module Math
    module Symbols
      class Tieinfty < Symbol
        INPUT = {
          unicodemath: [["&#x29dd;"], parsing_wrapper(["tieinfty"], lang: :unicode)],
          asciimath: [["&#x29dd;"], parsing_wrapper(["tieinfty"], lang: :asciimath)],
          mathml: ["&#x29dd;"],
          latex: [["tieinfty", "&#x29dd;"]],
          omml: ["&#x29dd;"],
          html: ["&#x29dd;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\tieinfty"
        end

        def to_asciimath(**)
          parsing_wrapper("tieinfty", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29dd;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29dd;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29dd;"
        end

        def to_html(**)
          "&#x29dd;"
        end
      end
    end
  end
end
