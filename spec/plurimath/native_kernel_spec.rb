# frozen_string_literal: true

require "spec_helper"
require "plurimath/native_kernel"

RSpec.describe Plurimath::NativeKernel do
  let(:kernel) { described_class.allocate }
  let(:wire) { '{"ok":true}' }
  let(:pointer) { Fiddle::Pointer[wire] }
  let(:evaluate) { instance_spy(Fiddle::Function) }
  let(:release) { instance_spy(Fiddle::Function) }

  before do
    kernel.instance_variable_set(:@evaluate, evaluate)
    kernel.instance_variable_set(:@free, release)
  end

  it "copies the native wire and releases its allocation once" do
    allow(evaluate).to receive(:call).and_return(pointer)
    expect(kernel.call("{}")).to eq(wire)
    expect(evaluate).to have_received(:call).with(anything, 2).once
    expect(release).to have_received(:call).with(pointer).once
  end

  it "releases the native allocation when copying raises" do
    allow(evaluate).to receive(:call).and_return(pointer)
    allow(kernel).to receive(:copy_response).and_raise(NoMemoryError, "copy")
    expect { kernel.call("{}") }.to raise_error(described_class::AllocationError)
    expect(release).to have_received(:call).with(pointer).once
  end

  it "returns a typed runtime failure for a null result" do
    allow(evaluate).to receive(:call).and_return(Fiddle::Pointer.new(0))
    expect { kernel.call("{}") }.to raise_error(described_class::ResultUnavailable)
    expect(release).not_to have_received(:call)
  end

  it "requires serialized string input" do
    expect { kernel.call({}) }.to raise_error(TypeError)
    expect(evaluate).not_to have_received(:call)
  end

  it "checks the source digest before loading a library" do
    allow(File).to receive(:expand_path).with("kernel.so").and_return("/kernel.so")
    allow(Digest::SHA256).to receive(:file).with("/kernel.so")
      .and_return(instance_double(Digest::SHA256, hexdigest: "actual"))
    allow(Fiddle).to receive(:dlopen)
    expect do
      described_class.new("kernel.so", sha256: "different")
    end.to raise_error(described_class::LoadError, /digest mismatch/)
    expect(Fiddle).not_to have_received(:dlopen)
  end
end
