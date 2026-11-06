# frozen_string_literal: true

# Decides, per example, whether the second XML engine pass can change the
# result.
#
# Every example runs first with the Ox engine. While it runs, this module
# records whether the example reached the XML layer: a read of
# `Plurimath.xml_engine` or of mml's adapter setting, a call into plurimath's
# Ox engine, or a call into Ox or the Ox adapters that lutaml-model and moxml
# use for MathML and OMML. The engine
# switch in the spec helper changes only those two settings, so an example
# that reached neither does the same work under Oga, and its Oga pass is
# skipped. An example that reached either runs again under Oga, as before.
#
# Tag a group or example with `engine_loop: :always` to force the Oga pass.
module EngineLoop
  # Classes and modules whose use under Ox means the example is XML-touching.
  # Inherited methods count too, so a call to an adapter method defined in a
  # shared base class is still seen. Constants missing at load time (lutaml,
  # mml and moxml load lazily) are instrumented as soon as they appear.
  TARGETS = %w[
    Plurimath::XmlEngine::OxEngine
    Plurimath::XmlEngine::OxEngine::Element
    Lutaml::Xml::Adapter::OxAdapter
    Moxml::Adapter::Ox
    Moxml::Adapter::CustomizedOx
    Mml::V4::Configuration
    Ox
    Ox::Element
    Ox::Document
  ].freeze

  @touched = false
  @watching = false
  @done = {}
  @counts = Hash.new(0)

  class << self
    attr_accessor :touched
    attr_reader :counts

    # With ENGINE_LOOP_TRACE set, prints where each example first reached
    # the XML layer during its Ox pass.
    def touch!(what = nil)
      if @watching && !@touched && ENV["ENGINE_LOOP_TRACE"]
        warn "engine-loop: #{what} from #{caller(2, 4).join(' <- ')}"
      end
      @touched = true
    end

    # Instruments every target that has been defined since the last call and
    # returns true when there was at least one.
    def instrument_available!
      added = false
      TARGETS.each do |name|
        next if @done[name]

        target = resolve(name)
        next unless target

        instrument(target)
        @done[name] = true
        added = true
      end
      added
    end

    # Runs the example under Ox, then under Oga only when the Ox pass reached
    # the XML layer (or the example asks for both passes).
    def run(example)
      instrument_available!
      use(Plurimath::XmlEngine::OxEngine, :ox)
      @touched = false
      @watching = true
      begin
        example.run
      ensure
        @watching = false
      end
      # A target first loaded by this example was not instrumented while the
      # example used it, so its Ox pass counts as XML-touching.
      @touched = true if instrument_available!
      return count(:ox_only) unless @touched || example.metadata[:engine_loop] == :always

      use(Plurimath::XmlEngine::Oga, :oga)
      example.run
      count(:both)
    end

    def summary
      both = @counts[:both]
      once = @counts[:ox_only]
      "Engine loop: #{both} examples ran on Ox and Oga; " \
        "#{once} did not reach the XML layer and ran on Ox only."
    end

    private

    def count(key)
      @counts[key] += 1
    end

    def use(engine, adapter)
      Plurimath.xml_engine = engine
      Mml::V4::Configuration.adapter = adapter
    end

    def resolve(name)
      name.split("::").reduce(Object) do |scope, part|
        return nil unless scope.const_defined?(part, false)

        scope.const_get(part, false)
      end
    end

    def instrument(target)
      names = method_names(target, Object)
      names << :initialize if target.private_method_defined?(:initialize, false)
      wrap(target, names)
      wrap(target.singleton_class, method_names(target.singleton_class, target.is_a?(Class) ? Class : Module))
    end

    def method_names(owner, base)
      names = owner.instance_methods(true) + owner.private_instance_methods(true)
      names - base.instance_methods(true) - base.private_instance_methods(true)
    end

    def wrap(owner, names)
      return if names.empty?

      owner.prepend(Module.new do
        names.each do |name|
          define_method(name) do |*args, **kwargs, &block|
            EngineLoop.touch!(name)
            super(*args, **kwargs, &block)
          end
        end
      end)
    end
  end
end

# `Plurimath.xml_engine` is how plurimath's own code reaches the XML layer.
Plurimath.singleton_class.prepend(Module.new do
  def xml_engine
    EngineLoop.touch!(:xml_engine)
    super
  end
end)
