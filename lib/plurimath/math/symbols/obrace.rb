module Plurimath
  module Math
    module Symbols
      class Obrace < Symbol
        INPUT = {
          unicodemath: [["&#x23de;"]],
          asciimath: [["&#x23de;"]],
          mathml: ["&#x23de;"],
          latex: [["&#x23de;"]],
          omml: ["&#x23de;"],
          html: ["&#x23de;"],
        }.freeze

        # output methods
        def to_latex(**)
          parsing_wrapper("obrace", lang: :latex)
        end

        def to_asciimath(**)
          parsing_wrapper("obrace", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23de;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23de;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23de;"
        end

        def to_html(**)
          "&#x23de;"
        end
      end
    end
  end
end
