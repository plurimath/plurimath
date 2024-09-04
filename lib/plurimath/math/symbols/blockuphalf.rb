module Plurimath
  module Math
    module Symbols
      class Blockuphalf < Symbol
        INPUT = {
          unicodemath: [["&#x2580;"], parsing_wrapper(["blockuphalf"], lang: :unicode)],
          asciimath: [["&#x2580;"], parsing_wrapper(["blockuphalf"], lang: :asciimath)],
          mathml: ["&#x2580;"],
          latex: [["blockuphalf", "&#x2580;"]],
          omml: ["&#x2580;"],
          html: ["&#x2580;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blockuphalf"
        end

        def to_asciimath(**)
          parsing_wrapper("blockuphalf", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2580;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2580;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2580;"
        end

        def to_html(**)
          "&#x2580;"
        end
      end
    end
  end
end
