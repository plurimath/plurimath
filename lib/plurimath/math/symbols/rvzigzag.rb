module Plurimath
  module Math
    module Symbols
      class Rvzigzag < Symbol
        INPUT = {
          unicodemath: [["&#x29db;"], parsing_wrapper(["Rvzigzag"], lang: :unicode)],
          asciimath: [["&#x29db;"], parsing_wrapper(["Rvzigzag"], lang: :asciimath)],
          mathml: ["&#x29db;"],
          latex: [["Rvzigzag", "&#x29db;"]],
          omml: ["&#x29db;"],
          html: ["&#x29db;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Rvzigzag"
        end

        def to_asciimath(**)
          parsing_wrapper("Rvzigzag", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29db;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29db;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29db;"
        end

        def to_html(**)
          "&#x29db;"
        end
      end
    end
  end
end
