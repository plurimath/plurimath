module Plurimath
  module Math
    module Symbols
      class Barwedge < Symbol
        INPUT = {
          unicodemath: [["&#x22bc;"], parsing_wrapper(["barwedge"], lang: :unicode)],
          asciimath: [["&#x22bc;"], parsing_wrapper(["barwedge"], lang: :asciimath)],
          mathml: ["&#x22bc;"],
          latex: [["barwedge", "&#x22bc;"]],
          omml: ["&#x22bc;"],
          html: ["&#x22bc;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\barwedge"
        end

        def to_asciimath(**)
          parsing_wrapper("barwedge", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22bc;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22bc;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22bc;"
        end

        def to_html(**)
          "&#x22bc;"
        end
      end
    end
  end
end
