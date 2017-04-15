#ifndef RENDER_H__
#define RENDER_H__ 

#include <stdio.h>
#include <pango/pango.h>

typedef struct _PangoViewer PangoViewer;

struct _PangoViewer {

  const char *name;

  const char *id;

  const char *write_suffix;

  gpointer (*create) (const PangoViewer *klass);

  void (*destroy) (gpointer instance);

  PangoContext * (*get_context) (gpointer instance);

  gpointer (*create_surface) (gpointer instance,
                  int      width,
                  int      height);

  void (*destroy_surface) (gpointer instance,
               gpointer surface);

  void (*render) (gpointer      instance,
          gpointer      surface,
          PangoContext *context,
          int          *width,
          int          *height,
          gpointer      state);

  /* The following can be NULL */

  void (*write) (gpointer instance,
         gpointer surface,
         FILE    *stream,
         int      width,
         int      height);

  gpointer (*create_window) (gpointer    instance,
                 const char *title,
                 int         width,
                 int         height);

  void (*destroy_window) (gpointer instance,
              gpointer window);

  gpointer (*display) (gpointer instance,
               gpointer surface,
               gpointer window,
               int      width,
               int      height,
               gpointer state);

  void (*load) (gpointer instance,
        gpointer surface,
        guchar  *buffer,
        int      width,
        int      height,
        int      stride);

  void (*save) (gpointer instance,
        gpointer surface,
        guchar  *buffer,
        int      width,
        int      height,
        int      stride);

  GOptionGroup * (*get_option_group) (const PangoViewer *klass);
};

extern const PangoViewer pangoft2_viewer;

void render_setopt_dpi(int dpi);
void render_setopt_text(const char* txt);


#endif