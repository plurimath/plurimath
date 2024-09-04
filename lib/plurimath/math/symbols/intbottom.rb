module Plurimath
  module Math
    module Symbols
      class Intbottom < Symbol
        INPUT = {
          unicodemath: [["&#x2321;"], parsing_wrapper(["intbottom"], lang: :unicode)],
          asciimath: [["&#x2321;"], parsing_wrapper(["intbottom"], lang: :asciimath)],
          mathml: ["&#x2321;"],
          latex: [["intbottom", "&#x2321;"]],
          omml: ["&#x2321;"],
          html: ["&#x2321;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\intbottom"
        end

        def to_asciimath(**)
          parsing_wrapper("intbottom", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2321;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2321;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2321;"
        end

        def to_html(**)
          "&#x2321;"
        end
      end
    end
  end
end
