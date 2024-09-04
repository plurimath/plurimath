module Plurimath
  module Math
    module Symbols
      class Vbraceextender < Symbol
        INPUT = {
          unicodemath: [["&#x23aa;"], parsing_wrapper(["vbraceextender"], lang: :unicode)],
          asciimath: [["&#x23aa;"], parsing_wrapper(["vbraceextender"], lang: :asciimath)],
          mathml: ["&#x23aa;"],
          latex: [["vbraceextender", "&#x23aa;"]],
          omml: ["&#x23aa;"],
          html: ["&#x23aa;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\vbraceextender"
        end

        def to_asciimath(**)
          parsing_wrapper("vbraceextender", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23aa;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23aa;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23aa;"
        end

        def to_html(**)
          "&#x23aa;"
        end
      end
    end
  end
end
