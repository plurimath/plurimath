module Plurimath
  module Math
    module Symbols
      class Ppprime < Symbol
        INPUT = {
          unicodemath: [["ppprime", "&#x2034;"], parsing_wrapper(["trprime", "third"], lang: :unicode)],
          asciimath: [["&#x2034;"], parsing_wrapper(["ppprime", "trprime", "third"], lang: :asciimath)],
          mathml: ["&#x2034;"],
          latex: [["trprime", "third", "&#x2034;"], parsing_wrapper(["ppprime"], lang: :latex)],
          omml: ["&#x2034;"],
          html: ["&#x2034;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\trprime"
        end

        def to_asciimath(**)
          parsing_wrapper("ppprime", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2034;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2034;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2034;"
        end

        def to_html(**)
          "&#x2034;"
        end
      end
    end
  end
end
