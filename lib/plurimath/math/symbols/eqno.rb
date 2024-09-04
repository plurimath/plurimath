module Plurimath
  module Math
    module Symbols
      class Eqno < Symbol
        INPUT = {
          unicodemath: [["eqno", "&#x23;"], parsing_wrapper(["#", "octothorpe"], lang: :unicode)],
          asciimath: [["#", "&#x23;"], parsing_wrapper(["eqno", "octothorpe"], lang: :asciimath)],
          mathml: ["&#x23;"],
          latex: [["octothorpe", "#", "&#x23;"], parsing_wrapper(["eqno"], lang: :latex)],
          omml: ["&#x23;"],
          html: ["&#x23;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\octothorpe"
        end

        def to_asciimath(**)
          parsing_wrapper("eqno", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23;"
        end

        def to_html(**)
          "&#x23;"
        end
      end
    end
  end
end
