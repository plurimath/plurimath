module Plurimath
  module Math
    module Symbols
      class Hash < Symbol
        INPUT = {
          unicodemath: [["&#x22d5;"], parsing_wrapper(["equalparallel", "hash"], lang: :unicode)],
          asciimath: [["&#x22d5;"], parsing_wrapper(["equalparallel", "hash"], lang: :asciimath)],
          mathml: ["&#x22d5;"],
          latex: [["equalparallel", "hash", "&#x22d5;"]],
          omml: ["&#x22d5;"],
          html: ["&#x22d5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\equalparallel"
        end

        def to_asciimath(**)
          parsing_wrapper("hash", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22d5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22d5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22d5;"
        end

        def to_html(**)
          "&#x22d5;"
        end
      end
    end
  end
end
