# frozen_string_literal: true

require 'unicode2latex'
# @example
# text = 'M =
#   \begin{bmatrix}
#   -\sin λ_0 & \cos λ_0 & 0 \\
#   -\sin φ_0 \cos λ_0 & -\sin φ_0 \sin λ_0 & \cos φ_0 \\
#   \cos φ_0 \cos λ_0 & \cos φ_0 \sin λ_0 & \sin φ_0
#   \end{bmatrix}'
# unicode = Unicode2LaTeX.unicode2latex(text)
# unicode # =>
# 'M =
#   \begin{bmatrix}
#   -\sin \lambda_0 & \cos \lambda_0 & 0 \\
#   -\sin \varphi_0 \cos \lambda_0 & -\sin \varphi_0 \sin \lambda_0 & \cos \varphi_0 \\
#   \cos \varphi_0 \cos \lambda_0 & \cos \varphi_0 \sin \lambda_0 & \sin \varphi_0
#   \end{bmatrix}'
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
