module Plurimath
  module Math
    module Symbols
      class Apluparrowbox < Symbol
        INPUT = {
          unicodemath: [["&#x2350;"], parsing_wrapper(["APLuparrowbox"], lang: :unicode)],
          asciimath: [["&#x2350;"], parsing_wrapper(["APLuparrowbox"], lang: :asciimath)],
          mathml: ["&#x2350;"],
          latex: [["APLuparrowbox", "&#x2350;"]],
          omml: ["&#x2350;"],
          html: ["&#x2350;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\APLuparrowbox"
        end

        def to_asciimath(**)
          parsing_wrapper("APLuparrowbox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2350;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2350;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2350;"
        end

        def to_html(**)
          "&#x2350;"
        end
      end
    end
  end
end
