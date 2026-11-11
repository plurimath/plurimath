# Native evaluation requests

The canonical native kernel accepts the numeric, quantity and GUM serialized
request profiles through one ABI. It provides the same response bytes used by
the Python and TypeScript/WASM bindings.

Install Fiddle and use a library built for the current platform. Initialize
the kernel with the library's pinned SHA-256 before processing requests.

```ruby
require "plurimath/native_kernel"

kernel = Plurimath::NativeKernel.new(
  "/absolute/path/libplurimath_numeric.so",
  sha256: expected_library_sha256,
)
wire = kernel.call(request_json)
```

Initialization verifies the library bytes and ABI version. Each call borrows
the request string, copies the response and frees its native allocation. A
native refusal remains the serialized response. A library or allocation
failure raises a typed binding error.

The kernel holds Ruby's GVL while native code borrows the input buffer.
Requests execute without reading the filesystem or environment after
initialization. The same kernel can process subsequent requests after a
typed evaluation refusal.
