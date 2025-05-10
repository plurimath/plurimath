#ifndef RENDER_H
#define RENDER_H

#include <ruby.h>
#include <cairo-svg.h>
#include <cairo-pdf.h>
#include <lsm.h>
#include <lsmmathml.h>
#include <lsmsvg.h>
#include <glib.h>
#include <glib/gi18n.h>
#include <gio/gio.h>

LsmDomDocument *lsm_dom_document_new_from_memory(const char *data, gssize size, GError **error);
LsmDomView *lsm_dom_document_create_view(LsmDomDocument *document);
void lsm_dom_view_set_resolution(LsmDomView *view, double ppi);
void lsm_dom_view_get_size(LsmDomView *view, double *width, double *height, double *baseline);
void lsm_dom_view_get_size_pixels(LsmDomView *view, unsigned int *width, unsigned int *height, unsigned int *baseline);
void lsm_dom_view_render(LsmDomView *view, cairo_t *cr, double x, double y);

#endif