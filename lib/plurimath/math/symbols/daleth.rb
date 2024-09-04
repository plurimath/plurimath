module Plurimath
  module Math
    module Symbols
      class Daleth < Symbol
        INPUT = {
          unicodemath: [["daleth", "&#x2138;"]],
          asciimath: [["&#x2138;"], parsing_wrapper(["daleth"], lang: :asciimath)],
          mathml: ["&#x2138;"],
          latex: [["daleth", "&#x2138;"]],
          omml: ["&#x2138;"],
          html: ["&#x2138;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\daleth"
        end

        def to_asciimath(**)
          parsing_wrapper("daleth", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2138;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2138;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2138;"
        end

        def to_html(**)
          "&#x2138;"
        end
      end
    end
  end
end
