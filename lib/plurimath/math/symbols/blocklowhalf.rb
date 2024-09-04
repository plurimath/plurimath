module Plurimath
  module Math
    module Symbols
      class Blocklowhalf < Symbol
        INPUT = {
          unicodemath: [["&#x2584;"], parsing_wrapper(["blocklowhalf"], lang: :unicode)],
          asciimath: [["&#x2584;"], parsing_wrapper(["blocklowhalf"], lang: :asciimath)],
          mathml: ["&#x2584;"],
          latex: [["blocklowhalf", "&#x2584;"]],
          omml: ["&#x2584;"],
          html: ["&#x2584;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blocklowhalf"
        end

        def to_asciimath(**)
          parsing_wrapper("blocklowhalf", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2584;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2584;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2584;"
        end

        def to_html(**)
          "&#x2584;"
        end
      end
    end
  end
end
