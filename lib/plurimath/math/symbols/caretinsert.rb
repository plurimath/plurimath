module Plurimath
  module Math
    module Symbols
      class Caretinsert < Symbol
        INPUT = {
          unicodemath: [["&#x2038;"], parsing_wrapper(["caretinsert"], lang: :unicode)],
          asciimath: [["&#x2038;"], parsing_wrapper(["caretinsert"], lang: :asciimath)],
          mathml: ["&#x2038;"],
          latex: [["caretinsert", "&#x2038;"]],
          omml: ["&#x2038;"],
          html: ["&#x2038;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\caretinsert"
        end

        def to_asciimath(**)
          parsing_wrapper("caretinsert", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2038;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2038;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2038;"
        end

        def to_html(**)
          "&#x2038;"
        end
      end
    end
  end
end
