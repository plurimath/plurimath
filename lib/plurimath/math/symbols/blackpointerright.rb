module Plurimath
  module Math
    module Symbols
      class Blackpointerright < Symbol
        INPUT = {
          unicodemath: [["&#x25ba;"], parsing_wrapper(["blackpointerright"], lang: :unicode)],
          asciimath: [["&#x25ba;"], parsing_wrapper(["blackpointerright"], lang: :asciimath)],
          mathml: ["&#x25ba;"],
          latex: [["blackpointerright", "&#x25ba;"]],
          omml: ["&#x25ba;"],
          html: ["&#x25ba;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blackpointerright"
        end

        def to_asciimath(**)
          parsing_wrapper("blackpointerright", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25ba;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25ba;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25ba;"
        end

        def to_html(**)
          "&#x25ba;"
        end
      end
    end
  end
end
