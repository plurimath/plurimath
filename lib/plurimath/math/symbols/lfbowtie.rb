module Plurimath
  module Math
    module Symbols
      class Lfbowtie < Symbol
        INPUT = {
          unicodemath: [["&#x29d1;"], parsing_wrapper(["lfbowtie"], lang: :unicode)],
          asciimath: [["&#x29d1;"], parsing_wrapper(["lfbowtie"], lang: :asciimath)],
          mathml: ["&#x29d1;"],
          latex: [["lfbowtie", "&#x29d1;"]],
          omml: ["&#x29d1;"],
          html: ["&#x29d1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lfbowtie"
        end

        def to_asciimath(**)
          parsing_wrapper("lfbowtie", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29d1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29d1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29d1;"
        end

        def to_html(**)
          "&#x29d1;"
        end
      end
    end
  end
end
