module Plurimath
  module Math
    module Symbols
      class Rightrightharpoons < Symbol
        INPUT = {
          unicodemath: [["&#x2964;"], parsing_wrapper(["rightharpoonsupdown", "rightrightharpoons"], lang: :unicode)],
          asciimath: [["&#x2964;"], parsing_wrapper(["rightharpoonsupdown", "rightrightharpoons"], lang: :asciimath)],
          mathml: ["&#x2964;"],
          latex: [["rightharpoonsupdown", "rightrightharpoons", "&#x2964;"]],
          omml: ["&#x2964;"],
          html: ["&#x2964;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightharpoonsupdown"
        end

        def to_asciimath(**)
          parsing_wrapper("rightrightharpoons", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2964;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2964;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2964;"
        end

        def to_html(**)
          "&#x2964;"
        end
      end
    end
  end
end
