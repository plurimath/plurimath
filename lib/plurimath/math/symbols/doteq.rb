module Plurimath
  module Math
    module Symbols
      class Doteq < Symbol
        INPUT = {
          unicodemath: [["Doteq", "&#x2251;"], parsing_wrapper(["doteqdot"], lang: :unicode)],
          asciimath: [["&#x2251;"], parsing_wrapper(["Doteq", "doteqdot"], lang: :asciimath)],
          mathml: ["&#x2251;"],
          latex: [["doteqdot", "Doteq", "&#x2251;"]],
          omml: ["&#x2251;"],
          html: ["&#x2251;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Doteq"
        end

        def to_asciimath(**)
          parsing_wrapper("Doteq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2251;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2251;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2251;"
        end

        def to_html(**)
          "&#x2251;"
        end
      end
    end
  end
end
