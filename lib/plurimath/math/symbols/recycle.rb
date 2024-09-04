module Plurimath
  module Math
    module Symbols
      class Recycle < Symbol
        INPUT = {
          unicodemath: [["&#x267b;"], parsing_wrapper(["recycle"], lang: :unicode)],
          asciimath: [["&#x267b;"], parsing_wrapper(["recycle"], lang: :asciimath)],
          mathml: ["&#x267b;"],
          latex: [["recycle", "&#x267b;"]],
          omml: ["&#x267b;"],
          html: ["&#x267b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\recycle"
        end

        def to_asciimath(**)
          parsing_wrapper("recycle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x267b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x267b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x267b;"
        end

        def to_html(**)
          "&#x267b;"
        end
      end
    end
  end
end
