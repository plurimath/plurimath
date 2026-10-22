require "spec_helper"
require "support/shared_renderer_examples"

RSpec.describe Plurimath::Math::Formula do
  describe ".to_latex" do
    subject(:formula) { exp.to_latex.gsub(/\s/, "") }

    it_behaves_like "shared renderer fixture", "formula-latex-7-1"

    it_behaves_like "shared renderer fixture", "formula-latex-20-1"

    it_behaves_like "shared renderer fixture", "formula-latex-36-1"

    it_behaves_like "shared renderer fixture", "formula-latex-113-1"

    it_behaves_like "shared renderer fixture", "formula-latex-212-1"

    it_behaves_like "shared renderer fixture", "formula-latex-322-1"

    it_behaves_like "shared renderer fixture", "formula-latex-343-1"

    it_behaves_like "shared renderer fixture", "formula-latex-360-1"

    it_behaves_like "shared renderer fixture", "formula-latex-389-1"

    it_behaves_like "shared renderer fixture", "formula-latex-422-1"

    it_behaves_like "shared renderer fixture", "formula-latex-459-1"

    it_behaves_like "shared renderer fixture", "formula-latex-476-1"

    it_behaves_like "shared renderer fixture", "formula-latex-490-1"

    it_behaves_like "shared renderer fixture", "formula-latex-504-1"

    it_behaves_like "shared renderer fixture", "formula-latex-520-1"

    it_behaves_like "shared renderer fixture", "formula-latex-536-1"

    it_behaves_like "shared renderer fixture", "formula-latex-552-1"

    it_behaves_like "shared renderer fixture", "formula-latex-569-1"

    it_behaves_like "shared renderer fixture", "formula-latex-590-1"

    it_behaves_like "shared renderer fixture", "formula-latex-605-1"

    it_behaves_like "shared renderer fixture", "formula-latex-620-1"

    it_behaves_like "shared renderer fixture", "formula-latex-635-1"

    it_behaves_like "shared renderer fixture", "formula-latex-655-1"

    it_behaves_like "shared renderer fixture", "formula-latex-675-1"

    it_behaves_like "shared renderer fixture", "formula-latex-691-1"

    it_behaves_like "shared renderer fixture", "formula-latex-713-1"

    it_behaves_like "shared renderer fixture", "formula-latex-729-1"

    it_behaves_like "shared renderer fixture", "formula-latex-745-1"

    it_behaves_like "shared renderer fixture", "formula-latex-782-1"

    it_behaves_like "shared renderer fixture", "formula-latex-843-1"

    it_behaves_like "shared renderer fixture", "formula-latex-873-1"

    it_behaves_like "shared renderer fixture", "formula-latex-902-1"

    it_behaves_like "shared renderer fixture", "formula-latex-938-1"

    it_behaves_like "shared renderer fixture", "formula-latex-964-1"

    it_behaves_like "shared renderer fixture", "formula-latex-998-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1024-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1074-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1109-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1125-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1141-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1163-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1210-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1223-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1238-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1253-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1266-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1286-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1303-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1371-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1424-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1603-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1760-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1786-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1844-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1915-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1948-1"

    it_behaves_like "shared renderer fixture", "formula-latex-1987-1"

    it_behaves_like "shared renderer fixture", "formula-latex-2061-1"

    it_behaves_like "shared renderer fixture", "formula-latex-2238-1"

    it_behaves_like "shared renderer fixture", "formula-latex-2393-1"

    it_behaves_like "shared renderer fixture", "formula-latex-2462-1"

    it_behaves_like "shared renderer fixture", "formula-latex-2535-1"

    it_behaves_like "shared renderer fixture", "formula-latex-2576-1"

    it_behaves_like "shared renderer fixture", "formula-latex-2645-1"

    it_behaves_like "shared renderer fixture", "formula-latex-2693-1"

    it_behaves_like "shared renderer fixture", "formula-latex-2737-1"

    it_behaves_like "shared renderer fixture", "formula-latex-2804-1"

    it_behaves_like "shared renderer fixture", "formula-latex-2886-1"

    it_behaves_like "shared renderer fixture", "formula-latex-2951-1"

    it_behaves_like "shared renderer fixture", "formula-latex-3042-1"

    it_behaves_like "shared renderer fixture", "formula-latex-3329-1"

    it_behaves_like "shared renderer fixture", "formula-latex-3416-1"

    it_behaves_like "shared renderer fixture", "formula-latex-3444-1"

    it_behaves_like "shared renderer fixture", "formula-latex-3807-1"

    it_behaves_like "shared renderer fixture", "formula-latex-4122-1"

    it_behaves_like "shared renderer fixture", "formula-latex-4159-1"

    it_behaves_like "shared renderer fixture", "formula-latex-4502-1"

    it_behaves_like "shared renderer fixture", "formula-latex-4845-1"

    it_behaves_like "shared renderer fixture", "formula-latex-5115-1"

    it_behaves_like "shared renderer fixture", "formula-latex-5220-1"

    it_behaves_like "shared renderer fixture", "formula-latex-5280-1"

    it_behaves_like "shared renderer fixture", "formula-latex-5567-1"

    it_behaves_like "shared renderer fixture", "formula-latex-5658-1"

    it_behaves_like "shared renderer fixture", "formula-latex-5726-1"

    it_behaves_like "shared renderer fixture", "formula-latex-5791-1"

    it_behaves_like "shared renderer fixture", "formula-latex-5873-1"

    it_behaves_like "shared renderer fixture", "formula-latex-5895-1"

    it_behaves_like "shared renderer fixture", "formula-latex-5920-1"

    it_behaves_like "shared renderer fixture", "formula-latex-6095-1"

    it_behaves_like "shared renderer fixture", "formula-latex-6216-1"

    it_behaves_like "shared renderer fixture", "formula-latex-6504-1"

    it_behaves_like "shared renderer fixture", "formula-latex-6683-1"

    it_behaves_like "shared renderer fixture", "formula-latex-6993-1"

    it_behaves_like "shared renderer fixture", "formula-latex-7187-1"

    it_behaves_like "shared renderer fixture", "formula-latex-7245-1"

    it_behaves_like "shared renderer fixture", "formula-latex-7299-1"
    # structural_response_representation_schema_annotated => 54

    it_behaves_like "shared renderer fixture", "formula-latex-7349-1"

    it_behaves_like "shared renderer fixture", "formula-latex-7412-1"

    it_behaves_like "shared renderer fixture", "formula-latex-7443-1"

    it_behaves_like "shared renderer fixture", "formula-latex-7468-1"

    it_behaves_like "shared renderer fixture", "formula-latex-7520-1"

    it_behaves_like "shared renderer fixture", "formula-latex-7629-1"

    it_behaves_like "shared renderer fixture", "formula-latex-7760-1"

    it_behaves_like "shared renderer fixture", "formula-latex-7878-1"

    it_behaves_like "shared renderer fixture", "formula-latex-7984-1"

    it_behaves_like "shared renderer fixture", "formula-latex-8104-1"

    it_behaves_like "shared renderer fixture", "formula-latex-8213-1"

    it_behaves_like "shared renderer fixture", "formula-latex-8233-1"

    it_behaves_like "shared renderer fixture", "formula-latex-8255-1"

    it_behaves_like "shared renderer fixture", "formula-latex-8311-1"

    it_behaves_like "shared renderer fixture", "formula-latex-8328-1"

    it_behaves_like "shared renderer fixture", "formula-latex-8348-1"

    it_behaves_like "shared renderer fixture", "formula-latex-8406-1"

    it_behaves_like "shared renderer fixture", "formula-latex-8497-1"

    it_behaves_like "shared renderer fixture", "formula-latex-8535-1"

    it_behaves_like "shared renderer fixture", "formula-latex-8581-1"

    it_behaves_like "shared renderer fixture", "formula-latex-8714-1"

    it_behaves_like "shared renderer fixture", "formula-latex-8760-1"

    it_behaves_like "shared renderer fixture", "formula-latex-8863-1"

    it_behaves_like "shared renderer fixture", "formula-latex-8889-1"

    it_behaves_like "shared renderer fixture", "formula-latex-8935-1"

    it_behaves_like "shared renderer fixture", "formula-latex-8961-1"

    it_behaves_like "shared renderer fixture", "formula-latex-8993-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9019-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9065-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9109-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9148-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9185-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9222-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9264-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9301-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9341-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9369-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9409-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9428-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9445-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9462-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9479-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9502-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9519-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9542-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9561-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9578-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9609-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9633-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9664-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9688-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9719-1"

    it_behaves_like "shared renderer fixture", "formula-latex-9743-1"

    it_behaves_like "shared renderer fixture", "formula-latex-10158-1"

    it_behaves_like "shared renderer fixture", "formula-latex-10326-1"

    it_behaves_like "shared renderer fixture", "formula-latex-10494-1"

    it_behaves_like "shared renderer fixture", "formula-latex-10731-1"

    it_behaves_like "shared renderer fixture", "formula-latex-10746-1"

    it_behaves_like "shared renderer fixture", "formula-latex-10761-1"

    it_behaves_like "shared renderer fixture", "formula-latex-10776-1"

    it_behaves_like "shared renderer fixture", "formula-latex-10831-1"
    # results_schema_annotated

    it_behaves_like "shared renderer fixture", "formula-latex-10961-1"

    it_behaves_like "shared renderer fixture", "formula-latex-10983-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11024-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11049-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11094-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11111-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11124-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11137-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11154-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11171-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11207-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11243-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11262-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11284-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11338-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11354-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11367-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11419-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11437-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11456-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11472-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11496-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11520-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11544-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11566-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11579-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11601-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11614-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11636-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11655-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11669-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11695-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11721-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11747-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11767-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11784-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11807-1"
    # domain_schema_annotated

    it_behaves_like "shared renderer fixture", "formula-latex-11829-1"
    # finite_element_analysis_control_and_result_schema_annotated

    it_behaves_like "shared renderer fixture", "formula-latex-11930-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11954-1"

    it_behaves_like "shared renderer fixture", "formula-latex-11978-1"

    it_behaves_like "shared renderer fixture", "formula-latex-12000-1"

    it_behaves_like "shared renderer fixture", "formula-latex-12054-1"

    it_behaves_like "shared renderer fixture", "formula-latex-12108-1"

    it_behaves_like "shared renderer fixture", "formula-latex-12196-1"

    it_behaves_like "shared renderer fixture", "formula-latex-12265-1"

    it_behaves_like "shared renderer fixture", "formula-latex-12319-1"

    it_behaves_like "shared renderer fixture", "formula-latex-12424-1"

    it_behaves_like "shared renderer fixture", "formula-latex-12539-1"

    it_behaves_like "shared renderer fixture", "formula-latex-12689-1"

    it_behaves_like "shared renderer fixture", "formula-latex-12757-1"

    it_behaves_like "shared renderer fixture", "formula-latex-12787-1"

    it_behaves_like "shared renderer fixture", "formula-latex-12817-1"

    it_behaves_like "shared renderer fixture", "formula-latex-12851-1"

    it_behaves_like "shared renderer fixture", "formula-latex-12877-1"
    # 07-conditions.adoc

    it_behaves_like "shared renderer fixture", "formula-latex-12917-1"

    it_behaves_like "shared renderer fixture", "formula-latex-12988-1"

    it_behaves_like "shared renderer fixture", "formula-latex-13003-1"

    it_behaves_like "shared renderer fixture", "formula-latex-13019-1"

    it_behaves_like "shared renderer fixture", "formula-latex-13156-1"

    it_behaves_like "shared renderer fixture", "formula-latex-13293-1"

    it_behaves_like "shared renderer fixture", "formula-latex-13431-1"

    it_behaves_like "shared renderer fixture", "formula-latex-13564-1"
  end
end
