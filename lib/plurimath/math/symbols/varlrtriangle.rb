module Plurimath
  module Math
    module Symbols
      class Varlrtriangle < Symbol
        INPUT = {
          unicodemath: [["&#x22bf;"], parsing_wrapper(["varlrtriangle"], lang: :unicode)],
          asciimath: [["&#x22bf;"], parsing_wrapper(["varlrtriangle"], lang: :asciimath)],
          mathml: ["&#x22bf;"],
          latex: [["varlrtriangle", "&#x22bf;"]],
          omml: ["&#x22bf;"],
          html: ["&#x22bf;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varlrtriangle"
        end

        def to_asciimath(**)
          parsing_wrapper("varlrtriangle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22bf;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22bf;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22bf;"
        end

        def to_html(**)
          "&#x22bf;"
        end
      end
    end
  end
end
