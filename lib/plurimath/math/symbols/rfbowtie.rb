module Plurimath
  module Math
    module Symbols
      class Rfbowtie < Symbol
        INPUT = {
          unicodemath: [["&#x29d2;"], parsing_wrapper(["rfbowtie"], lang: :unicode)],
          asciimath: [["&#x29d2;"], parsing_wrapper(["rfbowtie"], lang: :asciimath)],
          mathml: ["&#x29d2;"],
          latex: [["rfbowtie", "&#x29d2;"]],
          omml: ["&#x29d2;"],
          html: ["&#x29d2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rfbowtie"
        end

        def to_asciimath(**)
          parsing_wrapper("rfbowtie", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29d2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29d2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29d2;"
        end

        def to_html(**)
          "&#x29d2;"
        end
      end
    end
  end
end
