module Plurimath
  module Math
    module Symbols
      class Gesdoto < Symbol
        INPUT = {
          unicodemath: [["&#x2a82;"], parsing_wrapper(["gesdoto"], lang: :unicode)],
          asciimath: [["&#x2a82;"], parsing_wrapper(["gesdoto"], lang: :asciimath)],
          mathml: ["&#x2a82;"],
          latex: [["gesdoto", "&#x2a82;"]],
          omml: ["&#x2a82;"],
          html: ["&#x2a82;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gesdoto"
        end

        def to_asciimath(**)
          parsing_wrapper("gesdoto", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a82;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a82;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a82;"
        end

        def to_html(**)
          "&#x2a82;"
        end
      end
    end
  end
end
