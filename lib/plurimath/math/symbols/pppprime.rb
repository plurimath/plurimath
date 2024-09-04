module Plurimath
  module Math
    module Symbols
      class Pppprime < Symbol
        INPUT = {
          unicodemath: [["pppprime", "&#x2057;"], parsing_wrapper(["fourth", "qprime"], lang: :unicode)],
          asciimath: [["&#x2057;"], parsing_wrapper(["pppprime", "fourth", "qprime"], lang: :asciimath)],
          mathml: ["&#x2057;"],
          latex: [["fourth", "qprime", "&#x2057;"], parsing_wrapper(["pppprime"], lang: :latex)],
          omml: ["&#x2057;"],
          html: ["&#x2057;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\fourth"
        end

        def to_asciimath(**)
          parsing_wrapper("pppprime", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2057;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2057;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2057;"
        end

        def to_html(**)
          "&#x2057;"
        end
      end
    end
  end
end
