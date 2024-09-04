module Plurimath
  module Math
    module Symbols
      class Whitesquaretickright < Symbol
        INPUT = {
          unicodemath: [["&#x27e5;"], parsing_wrapper(["whitesquaretickright"], lang: :unicode)],
          asciimath: [["&#x27e5;"], parsing_wrapper(["whitesquaretickright"], lang: :asciimath)],
          mathml: ["&#x27e5;"],
          latex: [["whitesquaretickright", "&#x27e5;"]],
          omml: ["&#x27e5;"],
          html: ["&#x27e5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\whitesquaretickright"
        end

        def to_asciimath(**)
          parsing_wrapper("whitesquaretickright", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27e5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27e5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27e5;"
        end

        def to_html(**)
          "&#x27e5;"
        end
      end
    end
  end
end
