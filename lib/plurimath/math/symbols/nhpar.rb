module Plurimath
  module Math
    module Symbols
      class Nhpar < Symbol
        INPUT = {
          unicodemath: [["&#x2af2;"], parsing_wrapper(["nhpar"], lang: :unicode)],
          asciimath: [["&#x2af2;"], parsing_wrapper(["nhpar"], lang: :asciimath)],
          mathml: ["&#x2af2;"],
          latex: [["nhpar", "&#x2af2;"]],
          omml: ["&#x2af2;"],
          html: ["&#x2af2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nhpar"
        end

        def to_asciimath(**)
          parsing_wrapper("nhpar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2af2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2af2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2af2;"
        end

        def to_html(**)
          "&#x2af2;"
        end
      end
    end
  end
end
