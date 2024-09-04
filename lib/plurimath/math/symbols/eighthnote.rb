module Plurimath
  module Math
    module Symbols
      class Eighthnote < Symbol
        INPUT = {
          unicodemath: [["&#x266a;"], parsing_wrapper(["eighthnote"], lang: :unicode)],
          asciimath: [["&#x266a;"], parsing_wrapper(["eighthnote"], lang: :asciimath)],
          mathml: ["&#x266a;"],
          latex: [["eighthnote", "&#x266a;"]],
          omml: ["&#x266a;"],
          html: ["&#x266a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\eighthnote"
        end

        def to_asciimath(**)
          parsing_wrapper("eighthnote", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x266a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x266a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x266a;"
        end

        def to_html(**)
          "&#x266a;"
        end
      end
    end
  end
end
