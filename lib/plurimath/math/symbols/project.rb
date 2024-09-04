module Plurimath
  module Math
    module Symbols
      class Project < Symbol
        INPUT = {
          unicodemath: [["&#x2a21;"], parsing_wrapper(["zproject", "project"], lang: :unicode)],
          asciimath: [["&#x2a21;"], parsing_wrapper(["zproject", "project"], lang: :asciimath)],
          mathml: ["&#x2a21;"],
          latex: [["zproject", "project", "&#x2a21;"]],
          omml: ["&#x2a21;"],
          html: ["&#x2a21;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\zproject"
        end

        def to_asciimath(**)
          parsing_wrapper("project", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a21;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a21;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a21;"
        end

        def to_html(**)
          "&#x2a21;"
        end
      end
    end
  end
end
