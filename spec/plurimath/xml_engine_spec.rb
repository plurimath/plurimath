require "spec_helper"
require "plurimath/xml_engine/oga"
require "plurimath/xml_engine/ox_engine" unless RUBY_ENGINE == "opal"

RSpec.describe Plurimath::XmlEngine do
  let(:engine) { Plurimath.xml_engine }

  let(:string_with_tricky_characters) do
    "\x01\x13\x19\x21\x7f\u0081\u00ff\n\u{1FAC3}Ú®'\"%%<>&&<αθσ"
  end

  let(:dumped_string_with_tricky_characters) do
    Plurimath::XmlEngine::Oga::Dumper.entities(
      string_with_tricky_characters,
    )
  end

  let(:dumped_attr_string_with_tricky_characters) do
    Plurimath::XmlEngine::Oga::Dumper.entities(
      string_with_tricky_characters, true
    )
  end

  let(:sample_document_xml) do
    <<~XML
      <test a="b">
        <el/>
        <el c="d">#{dumped_string_with_tricky_characters}</el>
        <el c="#{dumped_attr_string_with_tricky_characters}"/>XXabcYY
        <el/>
      </test>
    XML
  end

  let(:sample_document) do
    build_sample_document(string_with_tricky_characters)
  end

  let(:sample_document_namespaced_xml) do
    <<~XML
      <?xml version="1.0" ?>
      <x xmlns="http://x.com" xmlns:y="http://y.com">
        <z/>
        <y:z/>
        <y:z t="3"/>
        <z y:t="3"/>
      </x>
    XML
  end

  let(:sample_document_namespaced) do
    engine.load sample_document_namespaced_xml
  end

  let(:sample_document_with_comments) do
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
  end

  let(:sample_mathml_document) do
    engine.load <<~MATHML
      <math>
        <mi> <!-- xxx --> &#x3C0;<!--GREEK SMALL LETTER PI--> </mi>
      </math>
    MATHML
  end

  def build_sample_document(text)
    root = engine.new_element("test")
    root["a"] = "b"
    el1 = engine.new_element("el")
    el2 = engine.new_element("el")
    el2["c"] = "d"
    el2 << text
    el3 = engine.new_element("el")
    el3["c"] = text
    el4 = engine.new_element("el")
    root << el1 << el2 << el3 << "XXabcYY" << el4
  end

  # XML 1.0 admits no C0 control other than tab, newline and carriage return,
  # not even as a character reference, so dumping drops them and no round trip
  # can bring them back.
  def without_illegal_c0_controls(text)
    text.delete("\x00-\x08\x0b\x0c\x0e-\x1f")
  end

  def c0_controls_xml_admits
    [0x09, 0x0a, 0x0d]
  end

  # Lexical, not semantic: what the engine wrote, not what a parser would
  # recover from it — a literal tab in an attribute normalises to a space. The
  # engines legitimately differ over which form they write. `x` must be
  # lowercase, `&#X9;` being no character reference, but its digits may be
  # either case.
  def written_as_code_point?(emitted, ord)
    emitted == ord.chr ||
      emitted.match?(/\A&#(?:x0*#{hex_digits(ord)}|0*#{ord});\z/)
  end

  def hex_digits(ord)
    ord.to_s(16).chars.map { |digit| "[#{digit}#{digit.upcase}]" }.join
  end

  # Replacing a control with some other character is neither writing it nor
  # dropping it, and is what keeping the three apart exists to catch.
  def c0_emission(emitted, ord)
    return :written if written_as_code_point?(emitted, ord)
    return :dropped if emitted.empty?

    emitted
  end

  def expected_c0_emissions
    (0x00..0x1f).to_h do |ord|
      [ord, c0_controls_xml_admits.include?(ord) ? :written : :dropped]
    end
  end

  def element_with_control_characters
    engine.new_element("el") << "a\x01b\x13c\x19d\ne"
  end

  # Wrapped in markers so whatever the engine emitted for the character, if
  # anything, can be read back out of a dump that also carries the engine's own
  # line breaks and indentation. `[\s\S]` rather than `.` under `/m`, which
  # captures nothing for a newline or a carriage return under the Opal this
  # project locks, and whose handling has differed across Opal versions.
  def dumped_text(control)
    element = engine.new_element("el") << "a#{control}b"

    engine.dump(element)[%r{<el>a([\s\S]*)b</el>}, 1]
  end

  def dumped_attribute(control)
    element = engine.new_element("el")
    element["c"] = "a#{control}b"

    engine.dump(element)[/ c="a([\s\S]*)b"/, 1]
  end

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

    describe "C0 controls in XML 1.0" do
      it "writes only the three it admits, in text" do
        emitted = (0x00..0x1f).to_h do |ord|
          [ord, c0_emission(dumped_text(ord.chr), ord)]
        end

        expect(emitted).to eq expected_c0_emissions
      end

      it "writes only the three it admits, in attributes" do
        emitted = (0x00..0x1f).to_h do |ord|
          [ord, c0_emission(dumped_attribute(ord.chr), ord)]
        end

        expect(emitted).to eq expected_c0_emissions
      end

      it "drops the rest instead of emitting a character reference" do
        dumped = engine.dump(element_with_control_characters)

        expect(dumped.strip).to eq "<el>abcd\ne</el>"
      end

      it "dumps a document that can be read back" do
        dumped = engine.dump(element_with_control_characters)

        expect(engine.load(dumped).nodes.first).to eq "abcd\ne"
      end
    end

    describe ".load" do
      it "loads simple document" do
        loaded = engine.load(sample_document_xml.gsub(/(>|YY)\s+(<|XX)/,
                                                      '\1\2'))

        expect(loaded)
          .to eq build_sample_document(
            without_illegal_c0_controls(string_with_tricky_characters),
          )
      end

      it "loads document with xmldecl and namespaces" do
        doc = sample_document_namespaced
        expect(doc.nodes.length).to be 1
        expect(doc.nodes.first.nodes.length).to be 4
        expect(doc.nodes.first.nodes.map(&:name)).to eq ["z"] * 4
        expect(doc.nodes.first.nodes.last(2).map do |i|
          i.attributes.keys
        end).to eq [["t"]] * 2
      end

      it "loads an element and handles text and whitespace in a consistent way" do
        loaded = engine.load(<<~XML)
          <root>  <a/>  &lt;  <b/>\t\n <c/> \n&lt;\n <!-- xx --> <!-- yy --> abc  </root>
        XML

        data = loaded.nodes.map { |i| i.instance_of?(String) ? i : :x }

        expect(data).to eq [:x, "  <  ", :x, :x, " \n<\n ", :x, :x, " abc  "]
      end

      it "loads entities correctly" do
        text = engine.load("<x>&alpha;&#x3b1;</x>").nodes.first
        expect(text).to eq "αα"
      end

      it "loads a sample mathml document as expected" do
        loaded = sample_mathml_document
        nodes = loaded.nodes.first.nodes
        nodes = nodes.map { |i| i.instance_of?(String) ? i : :x }
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

          data = root.nodes.map { |i| i.instance_of?(String) ? i : :x }

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

          expect(engine.dump(elem).strip).to eq '<a b="⌋"/>'
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
        expect(attrs).to eq({ "xmlns" => "http://x.com",
                              "y" => "http://y.com" })
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

  around do |example|
    old_engine = Plurimath.xml_engine
    Plurimath.xml_engine = tested_engine
    example.run
    Plurimath.xml_engine = old_engine
  end

  unless RUBY_ENGINE == "opal"
    describe "Ox" do
      let(:tested_engine) { Plurimath::XmlEngine::OxEngine }

      it_behaves_like "all engines"

      it "does not let a caller reinstate what it cannot represent" do
        element = engine.new_element("el") << "a\x01b"

        expect(engine.dump(element, invalid_replace: nil).strip)
          .to eq "<el>ab</el>"
      end
    end
  end

  describe "Oga" do
    let(:tested_engine) { Plurimath::XmlEngine::Oga }

    it_behaves_like "all engines"

    it "references a tab in an attribute, where a literal one would normalise" do
      element = engine.new_element("el")
      element["c"] = "a\tb"

      expect(engine.dump(element).strip).to eq %(<el c="a&#x0009;b"/>)
    end
  end
end
