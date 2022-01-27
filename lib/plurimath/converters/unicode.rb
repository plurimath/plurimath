# frozen_string_literal: true

require 'unicode2latex'
# Unicode
class Unicode
  attr_accessor :text

  def initialize(str)
    @text = str
  end

  def to_latex
    response = Unicode2LaTeX.unicode2latex(text)
    Latex.new(response)
  end
end
