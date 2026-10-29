require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Mathml::Parser do
  subject(:file) { File.read(file_name) }

  let(:mathml) do
    expected_value.to_mathml(split_on_linebreak: true,
                             unary_function_spacing: false)
  end

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-12-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-23-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-34-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-45-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-56-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-67-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-78-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-89-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-100-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-111-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-122-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-133-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-144-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-155-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-166-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-177-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-188-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-199-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-210-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-221-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-232-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-243-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-254-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-265-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-276-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-287-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-298-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-309-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-320-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-331-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-342-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-353-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-364-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-375-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-386-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-397-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-408-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-419-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-430-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-441-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-452-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-463-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-474-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-485-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-496-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-507-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-518-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-529-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-540-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-551-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-562-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-573-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-584-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-595-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-606-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-617-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-628-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-639-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-650-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-661-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-672-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-683-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-694-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-705-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-716-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-727-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-738-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-749-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-760-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-771-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-782-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-793-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-804-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-815-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-826-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-837-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-848-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-859-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-870-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-881-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-892-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-903-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-914-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-925-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-936-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-947-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-958-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-969-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-980-1"

  it_behaves_like "shared renderer fixture", "renderer-mathml-line_breaks-line_breaks-991-1"
end
