module Plurimath
  module Math
    module Symbols
      class Ltcc < Symbol
        INPUT = {
          unicodemath: [["&#x2aa6;"], parsing_wrapper(["leftslice", "ltcc"], lang: :unicode)],
          asciimath: [["&#x2aa6;"], parsing_wrapper(["leftslice", "ltcc"], lang: :asciimath)],
          mathml: ["&#x2aa6;"],
          latex: [["leftslice", "ltcc", "&#x2aa6;"]],
          omml: ["&#x2aa6;"],
          html: ["&#x2aa6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftslice"
        end

        def to_asciimath(**)
          parsing_wrapper("ltcc", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2aa6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2aa6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2aa6;"
        end

        def to_html(**)
          "&#x2aa6;"
        end
      end
    end
  end
end
