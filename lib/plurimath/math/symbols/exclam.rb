module Plurimath
  module Math
    module Symbols
      class Exclam < Symbol
        INPUT = {
          unicodemath: [["&#x21;"], parsing_wrapper(["!", "exclam"], lang: :unicode)],
          asciimath: [["!", "&#x21;"], parsing_wrapper(["exclam"], lang: :asciimath)],
          mathml: ["&#x21;"],
          latex: [["exclam", "!", "&#x21;"]],
          omml: ["&#x21;"],
          html: ["&#x21;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\exclam"
        end

        def to_asciimath(**)
          "!"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21;"
        end

        def to_html(**)
          "&#x21;"
        end
      end
    end
  end
end
