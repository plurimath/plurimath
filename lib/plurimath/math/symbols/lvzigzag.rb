module Plurimath
  module Math
    module Symbols
      class Lvzigzag < Symbol
        INPUT = {
          unicodemath: [["&#x29da;"], parsing_wrapper(["Lvzigzag"], lang: :unicode)],
          asciimath: [["&#x29da;"], parsing_wrapper(["Lvzigzag"], lang: :asciimath)],
          mathml: ["&#x29da;"],
          latex: [["Lvzigzag", "&#x29da;"]],
          omml: ["&#x29da;"],
          html: ["&#x29da;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Lvzigzag"
        end

        def to_asciimath(**)
          parsing_wrapper("Lvzigzag", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29da;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29da;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29da;"
        end

        def to_html(**)
          "&#x29da;"
        end
      end
    end
  end
end
