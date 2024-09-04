module Plurimath
  module Math
    module Symbols
      class Hearsuit < Symbol
        INPUT = {
          unicodemath: [["hearsuit", "&#x2661;"], parsing_wrapper(["heartsuit"], lang: :unicode)],
          asciimath: [["&#x2661;"], parsing_wrapper(["hearsuit", "heartsuit"], lang: :asciimath)],
          mathml: ["&#x2661;"],
          latex: [["heartsuit", "&#x2661;"], parsing_wrapper(["hearsuit"], lang: :latex)],
          omml: ["&#x2661;"],
          html: ["&#x2661;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\heartsuit"
        end

        def to_asciimath(**)
          parsing_wrapper("hearsuit", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2661;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2661;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2661;"
        end

        def to_html(**)
          "&#x2661;"
        end
      end
    end
  end
end
