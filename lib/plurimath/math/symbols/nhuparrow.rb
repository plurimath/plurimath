module Plurimath
  module Math
    module Symbols
      class Nhuparrow < Symbol
        INPUT = {
          unicodemath: [["&#x21de;"], parsing_wrapper(["nHuparrow"], lang: :unicode)],
          asciimath: [["&#x21de;"], parsing_wrapper(["nHuparrow"], lang: :asciimath)],
          mathml: ["&#x21de;"],
          latex: [["nHuparrow", "&#x21de;"]],
          omml: ["&#x21de;"],
          html: ["&#x21de;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nHuparrow"
        end

        def to_asciimath(**)
          parsing_wrapper("nHuparrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21de;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21de;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21de;"
        end

        def to_html(**)
          "&#x21de;"
        end
      end
    end
  end
end
