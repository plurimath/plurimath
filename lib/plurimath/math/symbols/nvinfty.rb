module Plurimath
  module Math
    module Symbols
      class Nvinfty < Symbol
        INPUT = {
          unicodemath: [["&#x29de;"], parsing_wrapper(["nvinfty"], lang: :unicode)],
          asciimath: [["&#x29de;"], parsing_wrapper(["nvinfty"], lang: :asciimath)],
          mathml: ["&#x29de;"],
          latex: [["nvinfty", "&#x29de;"]],
          omml: ["&#x29de;"],
          html: ["&#x29de;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nvinfty"
        end

        def to_asciimath(**)
          parsing_wrapper("nvinfty", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29de;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29de;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29de;"
        end

        def to_html(**)
          "&#x29de;"
        end
      end
    end
  end
end
