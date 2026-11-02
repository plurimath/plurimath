require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Omml::Parser do
  subject(:file) { File.read(file_name) }

  let(:omml) { expected_value.to_omml(split_on_linebreak: true) }

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-9-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-20-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-31-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-42-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-53-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-64-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-75-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-86-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-97-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-108-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-119-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-130-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-141-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-152-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-163-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-174-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-185-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-196-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-207-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-218-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-229-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-240-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-251-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-262-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-273-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-284-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-295-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-306-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-317-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-328-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-339-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-350-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-361-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-372-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-383-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-394-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-405-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-416-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-427-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-438-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-449-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-460-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-471-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-482-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-493-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-504-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-515-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-526-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-537-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-548-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-559-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-570-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-581-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-592-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-603-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-614-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-625-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-636-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-647-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-658-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-669-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-680-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-691-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-702-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-713-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-724-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-735-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-746-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-757-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-768-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-779-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-790-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-801-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-812-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-823-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-834-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-845-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-856-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-867-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-878-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-889-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-900-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-911-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-922-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-933-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-944-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-955-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-966-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-977-1"

  it_behaves_like "shared renderer fixture", "renderer-omml-line_breaks-line_breaks-988-1"
end
