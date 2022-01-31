require_relative '../../../lib/plurimath/plurimath'

RSpec.describe Unicode do

  it 'returns instance of Unicode' do
    raw_text = 'M =
                   \begin{bmatrix}
                    -\sin λ_0 & \cos λ_0 & 0 \\
                    -\sin φ_0 \cos λ_0 & -\sin φ_0 \sin λ_0 & \cos φ_0 \\
                    \cos φ_0 \cos λ_0 & \cos φ_0 \sin λ_0 & \sin φ_0
                   \end{bmatrix}'
    expect(Unicode.new(raw_text)).to be_a(Unicode)
  end

  it 'returns Latex instance' do
    raw_text = 'M =
                   \begin{bmatrix}
                    -\sin λ_0 & \cos λ_0 & 0 \\
                    -\sin φ_0 \cos λ_0 & -\sin φ_0 \sin λ_0 & \cos φ_0 \\
                    \cos φ_0 \cos λ_0 & \cos φ_0 \sin λ_0 & \sin φ_0
                   \end{bmatrix}'
    expect(Unicode.new(raw_text).to_latex).to be_a(Latex)
  end

  it 'converts Unicode to latex' do
    converted_str = "M =
                   \\begin{bmatrix}
                    -\\sin \\lambda_0 & \\cos \\lambda_0 & 0 \\
                    -\\sin \\varphi_0 \\cos \\lambda_0 & -\\sin \\varphi_0 \\sin \\lambda_0 & \\cos \\varphi_0 \\
                    \\cos \\varphi_0 \\cos \\lambda_0 & \\cos \\varphi_0 \\sin \\lambda_0 & \\sin \\varphi_0
                   \\end{bmatrix}"
    raw_text = 'M =
                   \begin{bmatrix}
                    -\sin λ_0 & \cos λ_0 & 0 \\
                    -\sin φ_0 \cos λ_0 & -\sin φ_0 \sin λ_0 & \cos φ_0 \\
                    \cos φ_0 \cos λ_0 & \cos φ_0 \sin λ_0 & \sin φ_0
                   \end{bmatrix}'
    expect(Unicode.new(raw_text).to_latex.text).to eql(converted_str)
  end
end
