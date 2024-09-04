module Plurimath
  module Math
    module Symbols
      class Sixteenthnote < Symbol
        INPUT = {
          unicodemath: [["&#x266c;"], parsing_wrapper(["sixteenthnote"], lang: :unicode)],
          asciimath: [["&#x266c;"], parsing_wrapper(["sixteenthnote"], lang: :asciimath)],
          mathml: ["&#x266c;"],
          latex: [["sixteenthnote", "&#x266c;"]],
          omml: ["&#x266c;"],
          html: ["&#x266c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sixteenthnote"
        end

        def to_asciimath(**)
          parsing_wrapper("sixteenthnote", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x266c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x266c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x266c;"
        end

        def to_html(**)
          "&#x266c;"
        end
      end
    end
  end
end
