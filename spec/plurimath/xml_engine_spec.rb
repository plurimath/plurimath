require "spec_helper"
require "plurimath/xml_engine/oga"
require "plurimath/xml_engine/ox" unless RUBY_ENGINE == 'opal'

RSpec.describe Plurimath::XMLEngine do
  let(:engine) { Plurimath.xml_engine }

  let(:string_with_tricky_characters) {
    "\x01\x13\x19\x21\x7f\u0081\u00ff\n\u{1FAC3}Ú®'\"%%<>&&amp;&lt;αθσ"
  }

  let(:dumped_string_with_tricky_characters) {
    Plurimath::XMLEngine::Oga::Dumper.entities(
      string_with_tricky_characters
    )
  }

  let(:dumped_attr_string_with_tricky_characters) {
    Plurimath::XMLEngine::Oga::Dumper.entities(
      string_with_tricky_characters, true
    )
  }

  let(:sample_document_xml) {
    <<~XML
      <test a="b">
        <el/>
        <el c="d">#{dumped_string_with_tricky_characters}</el>
        <el c="#{dumped_attr_string_with_tricky_characters}"/>XXabcYY
        <el/>
      </test>
    XML
  }

  let(:sample_document) {
    root = engine.new_element("test")
    root["a"] = "b"
    el1 = engine.new_element("el")
    el2 = engine.new_element("el")
    el2["c"] = "d"
    el2 << string_with_tricky_characters
    el3 = engine.new_element("el")
    el3["c"] = string_with_tricky_characters
    el4 = engine.new_element("el")
    root << el1 << el2 << el3 << "XXabcYY" << el4
  }

  let(:sample_document_namespaced_xml) {
    <<~XML
      <?xml version="1.0" ?>
      <x xmlns="http://x.com" xmlns:y="http://y.com">
        <z/>
        <y:z/>
        <y:z t="3"/>
        <z y:t="3"/>
      </x>
    XML
  }

  let(:sample_document_namespaced) {
    engine.load sample_document_namespaced_xml
  }

  let(:sample_document_with_comments) {
    engine.load <<~XML
      <x>
        <z/>
        <!-- sa -->
        <z>
          <!-- sa -->
          asd
          <!-- sa -->
          asasd
        </z>
      </x>
    XML
  }

  let(:sample_mathml_document) {
    engine.load <<~MATHML
      <math>
        <mi> <!-- xxx --> &#x3C0;<!--GREEK SMALL LETTER PI--> </mi>
      </math>
    MATHML
  }

  shared_examples "all engines" do
    it ".new_element" do
      elem = engine.new_element("elem")
      %i[nodes [] []= << attributes locate name name=].each do |method|
        expect(elem).to respond_to method
      end
    end

    describe ".dump" do
      it "dumps simple document" do
        dumped = engine.dump(sample_document, indent: 2)
        expect(dumped.strip).to eq sample_document_xml.strip
      end
    end

    describe ".load" do
      it "loads simple document" do
        loaded = engine.load(sample_document_xml.gsub(/(>|YY)\s+(<|XX)/, '\1\2'))
        expect(loaded).to eq sample_document
      end

      it "loads document with xmldecl and namespaces" do
        doc = sample_document_namespaced
        expect(doc.nodes.length).to be 1
        expect(doc.nodes.first.nodes.length).to be 4
        expect(doc.nodes.first.nodes.map(&:name)).to eq ["z"]*4
        expect(doc.nodes.first.nodes.last(2).map {|i| i.attributes.keys }).to eq [["t"]]*2
      end

      it "loads an element and handles text and whitespace in a consistent way" do
        loaded = engine.load(<<~XML)
          <root>  <a/>  &lt;  <b/>\t\n <c/> \n&lt;\n <!-- xx --> <!-- yy --> abc  </root>
        XML

        data = loaded.nodes.map { |i| i.class == String ? i : :x }

        expect(data).to eq [:x, "  <  ", :x, :x, " \n<\n ", :x, :x, " abc  "]
      end

      it "loads entities correctly" do
        text = engine.load("<x>&alpha;&#x3b1;</x>").nodes.first
        expect(text).to eq "αα"
      end

      it "loads a sample mathml document as expected" do
        loaded = sample_mathml_document
        nodes = loaded.nodes.first.nodes
        nodes = nodes.map { |i| i.class == String ? i : :x }
        expect(nodes).to eq [:x, " π", :x, " "]
      end
    end

    it ".is_xml_comment?" do
      nodes_1 = sample_document_with_comments.nodes
      comments_1 = nodes_1.map { |i| engine.is_xml_comment?(i) }
      nodes_2 = nodes_1[2].nodes
      comments_2 = nodes_2.map { |i| engine.is_xml_comment?(i) }
      expect(comments_1).to eq [false, true, false]
      expect(comments_2).to eq [true, false, true, false]
    end

    it ".replace_nodes?" do
      nodes = sample_document_with_comments.nodes
      expect(nodes[2].nodes.length).to eq 4
      engine.replace_nodes(nodes.first, "t")
      expect(nodes.first.nodes.length).to eq 1
    end

    describe "Node" do
      describe "#nodes" do
        it "handles basic documents correctly" do
          loaded = engine.load(sample_document_xml)
          expect(loaded.nodes.length).to be 5
        end

        it "handles documents with comments and text nodes correctly" do
          loaded = sample_document_with_comments
          expect(loaded.nodes.length).to be 3
          expect(loaded.nodes[2].nodes.length).to be 4
        end

        it "correctly returns whitespaced text children" do
          root = engine.new_element("test")
          root << "  " << engine.new_element("x") \
               << "  " << engine.new_element("x") << "  "

          data = root.nodes.map { |i| i.class == String ? i : :x }

          expect(data).to eq ["  ", :x, "  ", :x, "  "]
        end
      end

      it "#[]" do
        doc = sample_document_namespaced
        nodes = doc.nodes.first.nodes.last(2)
        expect(nodes[0]["t"]).to eq "3"
        expect(nodes[0][:t]).to eq "3"
        expect(nodes[1]["t"]).to eq "3"
        expect(nodes[1][:t]).to eq "3"
      end

      describe "#[]=" do
        it "works" do
          elem = engine.new_element("x:abc")
          elem["x:def"] = "ghi"
          elem["jkl"] = "mno"

          expect(engine.dump(elem).strip).to eq '<x:abc x:def="ghi" jkl="mno"/>'
        end

        it "does not decode entities when assigned" do
          elem = engine.new_element("a")
          elem["b"] = "&#x230b;"

          expect(engine.dump(elem).strip).to eq '<a b="&amp;#x230b;"/>'
        end
      end

      describe "#locate" do
        it "works" do
          located = sample_document_with_comments.locate("z")
          expect(located.length).to be 2
        end

        it "works with properties" do
          located = sample_document.locate("el/@c")
          expect(located).to eq ["d", string_with_tricky_characters]
        end
      end

      it "#name" do
        loaded = engine.load("<x:y/>")
        expect(loaded.name).to eq "y"
      end

      it "#name=" do
        elem = engine.new_element("x:y")
        elem.name = "y:z"
        expect(elem.name).to eq "y:z"
      end

      it "#attributes" do
        attrs = sample_document_namespaced.nodes.first.attributes
        expect(attrs).to eq({"xmlns"=>"http://x.com", "y"=>"http://y.com"})
      end

      describe "#<<" do
        it "does not decode entities" do
          a = engine.new_element("a")
          a << "&#x3b1;"
          expect(a.nodes.first).to eq("&#x3b1;")
          expect(engine.dump(a).strip).to eq "<a>&amp;#x3b1;</a>"
        end
      end
    end
  end

  around(:each) do |example|
    old_engine = Plurimath.xml_engine
    Plurimath.xml_engine = tested_engine
    example.run
    Plurimath.xml_engine = old_engine
  end

  describe "Ox" do
    let(:tested_engine) { Plurimath::XMLEngine::Ox }

    include_examples "all engines"
  end unless RUBY_ENGINE == "opal"

  describe "Oga" do
    let(:tested_engine) { Plurimath::XMLEngine::Oga }

    include_examples "all engines"
  end
end
