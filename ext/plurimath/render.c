#include <render.h>
#include <ruby.h>
#include <cairo.h>
#include <cairo-svg.h>
#include <cairo-pdf.h>
#include <lsm.h>
#include <stdarg.h>
#include <stdio.h>
#include <limits.h>
#include <lasemrender.c>

#define CSTR2SYM(str) ID2SYM(rb_intern(str))

static VALUE rb_mRender;
static VALUE rb_eMaxsizeError;
static VALUE rb_eParseError;
static VALUE rb_eDocumentCreationError;
static VALUE rb_eDocumentReadError;
VALUE rb_eTypeError; // Remove static keyword

// Function to print an error message and raise a Ruby exception
void print_and_raise(VALUE error_type, const char* format, ...) __attribute__((format(gnu_printf, 2, 3)));
void print_and_raise(VALUE error_type, const char* format, ...)
{
  va_list args;
  va_start(args, format);

  vfprintf(stderr, format, args);
  rb_raise(error_type, format, args);

  va_end(args);
}

// Function to handle exceptions during processing
static VALUE process_rescue(VALUE args, VALUE exception_object)
{
  VALUE rescue_hash = rb_hash_new();

  rb_hash_aset(rescue_hash, CSTR2SYM("data"), args);
  rb_hash_aset(rescue_hash, CSTR2SYM("exception"), exception_object);

  return rescue_hash;
}

// Core processing function
VALUE process(VALUE self, unsigned long maxsize, const char *mathml_code, unsigned long mathml_size, int format)
{
  // Check if the MathML string size exceeds the maximum allowed size
  if (mathml_size > maxsize) {
    print_and_raise(rb_eMaxsizeError, "Size of MathML string is greater than the maxsize");
  }

  VALUE result_hash = rb_hash_new();
  FileFormat file_format = (FileFormat) format;

  // Create a document from the MathML data
  LsmDomDocument *document;
  document = lsm_dom_document_new_from_memory(mathml_code, mathml_size, NULL);

  if (document == NULL) { print_and_raise(rb_eDocumentCreationError, "Failed to create document"); }

  LsmDomView *view;

  double ppi = NUM2DBL(rb_iv_get(self, "@ppi"));
  double zoom = NUM2DBL(rb_iv_get(self, "@zoom"));

  // Create a view for the document and set its resolution
  view = lsm_dom_document_create_view(document);
  lsm_dom_view_set_resolution(view, ppi);

  double width_pt = 2.0, height_pt = 2.0;
  unsigned int height, width;

  lsm_dom_view_get_size(view, &width_pt, &height_pt, NULL);
  lsm_dom_view_get_size_pixels(view, &width, &height, NULL);

  width_pt *= zoom;
  height_pt *= zoom;

  cairo_t *cairo;
  cairo_surface_t *surface;

  // Create a surface for the specified format (SVG, PNG, or PDF)
  if (file_format == FORMAT_SVG) {
    // surface = cairo_svg_surface_create_for_stream(cairoSvgSurfaceCallback, (void *)self, width_pt, height_pt);
  } else if (file_format == FORMAT_PNG) {
    // surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, width, height);
  } else if (file_format == FORMAT_PDF) {
    // surface = cairo_pdf_surface_create_for_stream(cairoPdfSurfaceCallback, (void *)self, width_pt, height_pt);
  } else {
    print_and_raise(rb_eTypeError, "Unsupported format");
  }

  cairo = cairo_create(surface);
  cairo_scale(cairo, zoom, zoom);
  lsm_dom_view_render(view, cairo, 0, 0);

  // Write the output to the appropriate format
  if (file_format == FORMAT_PNG) {
    // cairo_surface_write_to_png_stream(cairo_get_target(cairo), cairoPngSurfaceCallback, (void *)self);
  }

  cairo_destroy(cairo);
  cairo_surface_destroy(surface);
  g_object_unref(view);
  g_object_unref(document);

  // Handle the output for SVG and PNG formats
  if (file_format == FORMAT_SVG) {
    if (rb_iv_get(self, "@svg") == Qnil) { print_and_raise(rb_eDocumentReadError, "Failed to read SVG contents"); }
    rb_hash_aset(result_hash, CSTR2SYM("data"), rb_iv_get(self, "@svg"));
  } else if (file_format == FORMAT_PNG) {
    if (rb_iv_get(self, "@png") == Qnil) { print_and_raise(rb_eDocumentReadError, "Failed to read PNG contents"); }
    rb_hash_aset(result_hash, CSTR2SYM("data"), rb_iv_get(self, "@png"));
  } else if (file_format == FORMAT_PDF) {
    if (rb_iv_get(self, "@pdf") == Qnil) { print_and_raise(rb_eDocumentReadError, "Failed to read PDF contents"); }
    rb_hash_aset(result_hash, CSTR2SYM("data"), rb_iv_get(self, "@pdf"));
  } else {
    print_and_raise(rb_eTypeError, "not valid format");
  }

  rb_hash_aset(result_hash, CSTR2SYM("width"),  INT2FIX(width_pt));
  rb_hash_aset(result_hash, CSTR2SYM("height"), INT2FIX(height_pt));

  rb_iv_set(self, "@svg", Qnil);
  rb_iv_set(self, "@png", Qnil);
  rb_iv_set(self, "@pdf", Qnil);

  return result_hash;
}

// Helper function to pack arguments and call the process function
static VALUE process_helper(VALUE data)
{
  VALUE *args = (VALUE *) data;

  return process(args[0], NUM2ULONG(args[1]), StringValueCStr(args[2]), NUM2ULONG(args[3]), NUM2INT(args[4]));
}

// Ruby method to render MathML input
static VALUE render(VALUE self, VALUE rb_Input, VALUE rb_Format)
{
  Check_Type(rb_Format, T_FIXNUM);

  unsigned long maxsize = (unsigned long) FIX2INT(rb_iv_get(self, "@maxsize"));

  if (maxsize == 0) {
    maxsize = LONG_MAX;
  }

  #if !GLIB_CHECK_VERSION(2,36,0)
    g_type_init();
  #endif

  const char *mathml_code;
  unsigned long mathml_size;

  VALUE output;

  switch (TYPE(rb_Input)) {
    case T_STRING: {
      mathml_code = StringValueCStr(rb_Input);
      mathml_size = (unsigned long) strlen(mathml_code);

      VALUE args[5];
      args[0] = self;
      args[1] = ULONG2NUM(maxsize);
      args[2] = rb_Input;
      args[3] = ULONG2NUM(mathml_size);
      args[4] = rb_Format;

      output = rb_rescue(process_helper, (VALUE)&args[0], process_rescue, rb_Input);
      break;
    }
    default: {
      print_and_raise(rb_eTypeError, "not valid value");
      output = (VALUE)NULL;
      break;
    }
  }

  return output;
}

void g_option_context() {
  return g_option_context_new (NULL);
}

void g_option_entry() {
  return g_option_context_add_main_entries (g_option_context, entries, NULL);
}

void to_png(char *input_filename, char *output_filename) {
  LsmDomDocument *document;
	LsmDomView *view;
	cairo_t *cairo;
	cairo_surface_t *surface;
	double offset_x_pt = 0.0, offset_y_pt = 0.0;
	double height_pt, width_pt;
	unsigned int height, width;
	double size[2] = {0.0, 0.0};
	double offset[2] = {0.0, 0.0};

	document = lsm_dom_document_new_from_path (input_filename, NULL);

	view = lsm_dom_document_create_view (document);
	lsm_dom_view_set_resolution (view, 72.0);

	lsm_dom_view_get_size (view, &width_pt, &height_pt, NULL);
	lsm_dom_view_get_size_pixels (view, &width, &height, NULL);

	surface = cairo_image_surface_create (CAIRO_FORMAT_ARGB32, width, height);
	cairo = cairo_create (surface);
	cairo_surface_destroy (surface);
	cairo_scale (cairo, 1.0, 1.0);

	lsm_dom_view_render (view, cairo, -offset_x_pt, -offset_y_pt);

	cairo_surface_write_to_png (cairo_get_target (cairo), output_filename);

	cairo_destroy (cairo);
	g_object_unref (view);
	g_object_unref (document);
}

// Initialization function for the Ruby extension
void Init_render(void)
{
  VALUE rb_mPlurimath = rb_define_module("Plurimath");
  rb_mRender = rb_define_under_class(rb_mPlurimath, "Render", rb_cObject);

  rb_eMaxsizeError = rb_define_class_under(rb_mRender, "MaxsizeError", rb_eStandardError);
  rb_eParseError = rb_define_class_under(rb_mRender, "ParseError", rb_eStandardError);
  rb_eDocumentCreationError = rb_define_class_under(rb_mRender, "DocumentCreationError", rb_eStandardError);
  rb_eDocumentReadError = rb_define_class_under(rb_mRender, "DocumentReadError", rb_eStandardError);
  rb_eTypeError = rb_define_class_under(rb_mRender, "TypeError", rb_eStandardError);

  rb_define_method(rb_mRender, "render", render, 2);
  rb_define_method(rb_mRender, "process_helper", process_helper, 1);
  rb_define_method(rb_mRender, "process", process, 5);
  rb_define_method(rb_mRender, "g_option_entry", g_option_entry, 0);
  rb_define_method(rb_mRender, "to_png", to_png, 2);
}