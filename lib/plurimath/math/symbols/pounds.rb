module Plurimath
  module Math
    module Symbols
      class Pounds < Symbol
        INPUT = {
          unicodemath: [["&#xa3;"], parsing_wrapper(["mathsterling", "sterling", "pounds"], lang: :unicode)],
          asciimath: [["&#xa3;"], parsing_wrapper(["mathsterling", "sterling", "pounds"], lang: :asciimath)],
          mathml: ["&#xa3;"],
          latex: [["mathsterling", "sterling", "pounds", "&#xa3;"]],
          omml: ["&#xa3;"],
          html: ["&#xa3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mathsterling"
        end

        def to_asciimath(**)
          parsing_wrapper("pounds", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#xa3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#xa3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#xa3;"
        end

        def to_html(**)
          "&#xa3;"
        end
      end
    end
  end
end
