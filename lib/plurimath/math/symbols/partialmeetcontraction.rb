module Plurimath
  module Math
    module Symbols
      class Partialmeetcontraction < Symbol
        INPUT = {
          unicodemath: [["&#x2aa3;"], parsing_wrapper(["partialmeetcontraction"], lang: :unicode)],
          asciimath: [["&#x2aa3;"], parsing_wrapper(["partialmeetcontraction"], lang: :asciimath)],
          mathml: ["&#x2aa3;"],
          latex: [["partialmeetcontraction", "&#x2aa3;"]],
          omml: ["&#x2aa3;"],
          html: ["&#x2aa3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\partialmeetcontraction"
        end

        def to_asciimath(**)
          parsing_wrapper("partialmeetcontraction", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2aa3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2aa3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2aa3;"
        end

        def to_html(**)
          "&#x2aa3;"
        end
      end
    end
  end
end
