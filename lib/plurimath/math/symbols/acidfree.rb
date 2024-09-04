module Plurimath
  module Math
    module Symbols
      class Acidfree < Symbol
        INPUT = {
          unicodemath: [["&#x267e;"], parsing_wrapper(["acidfree"], lang: :unicode)],
          asciimath: [["&#x267e;"], parsing_wrapper(["acidfree"], lang: :asciimath)],
          mathml: ["&#x267e;"],
          latex: [["acidfree", "&#x267e;"]],
          omml: ["&#x267e;"],
          html: ["&#x267e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\acidfree"
        end

        def to_asciimath(**)
          parsing_wrapper("acidfree", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x267e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x267e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x267e;"
        end

        def to_html(**)
          "&#x267e;"
        end
      end
    end
  end
end
