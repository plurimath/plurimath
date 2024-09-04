module Plurimath
  module Math
    module Symbols
      class Nvdash < Symbol
        INPUT = {
          unicodemath: [["&#x22af;"], parsing_wrapper(["nVDash"], lang: :unicode)],
          asciimath: [["&#x22af;"], parsing_wrapper(["nVDash"], lang: :asciimath)],
          mathml: ["&#x22af;"],
          latex: [["nVDash", "&#x22af;"]],
          omml: ["&#x22af;"],
          html: ["&#x22af;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nVDash"
        end

        def to_asciimath(**)
          parsing_wrapper("nVDash", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22af;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22af;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22af;"
        end

        def to_html(**)
          "&#x22af;"
        end
      end
    end
  end
end
