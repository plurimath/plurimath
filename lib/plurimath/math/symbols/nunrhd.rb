module Plurimath
  module Math
    module Symbols
      class Nunrhd < Symbol
        INPUT = {
          unicodemath: [["ntrianglerighteq", "&#x22ed;"], parsing_wrapper(["nunrhd"], lang: :unicode)],
          asciimath: [["&#x22ed;"], parsing_wrapper(["ntrianglerighteq", "nunrhd"], lang: :asciimath)],
          mathml: ["&#x22ed;"],
          latex: [["ntrianglerighteq", "nunrhd", "&#x22ed;"]],
          omml: ["&#x22ed;"],
          html: ["&#x22ed;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ntrianglerighteq"
        end

        def to_asciimath(**)
          parsing_wrapper("nunrhd", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22ed;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22ed;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22ed;"
        end

        def to_html(**)
          "&#x22ed;"
        end
      end
    end
  end
end
