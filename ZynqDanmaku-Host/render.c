
#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <locale.h>

#include <glib.h>
#include <glib/gstdio.h>

#ifdef G_OS_UNIX
#include <sys/wait.h>
#endif
#include <pango/pangoft2.h>

#include "render.h"

int opt_dpi = 96*4;
int opt_runs = 1;
PangoGravity opt_gravity = PANGO_GRAVITY_SOUTH;
PangoGravityHint opt_gravity_hint = PANGO_GRAVITY_HINT_NATURAL;
const char *opt_font = "Source Han Sans CN,EmojiOne Color"; //Chinese and Emoji
static const char* text = "hello world";
const char* opt_output = "test.pgm";

void render_setopt_dpi(int dpi)
{
    opt_dpi = dpi;
}
void render_setopt_text(const char* txt)
{
    text = txt;
}

void
fail (const char *format, ...)
{
  const char *msg;

  va_list vap;
  va_start (vap, format);
  msg = g_strdup_vprintf (format, vap);
  g_printerr ("%s: %s\n", g_get_prgname (), msg);

  exit (1);
}

static void
substitute_func (FcPattern *pattern,
                 gpointer   data G_GNUC_UNUSED)
{
    /*
     if (opt_hinting != HINT_DEFAULT)
       {
         FcPatternDel (pattern, FC_HINTING);
         FcPatternAddBool (pattern, FC_HINTING, opt_hinting != HINT_NONE);

         FcPatternDel (pattern, FC_AUTOHINT);
         FcPatternAddBool (pattern, FC_AUTOHINT, opt_hinting == HINT_AUTO);
       }
    */
}

static gpointer
pangoft2_view_create (const PangoViewer *klass G_GNUC_UNUSED)
{
    PangoFontMap *fontmap;
    fontmap = pango_ft2_font_map_new ();

    pango_ft2_font_map_set_resolution (PANGO_FT2_FONT_MAP (fontmap), opt_dpi, opt_dpi);
    pango_ft2_font_map_set_default_substitute (PANGO_FT2_FONT_MAP (fontmap), substitute_func, NULL, NULL);

    return fontmap;
}

static void
pangoft2_view_destroy (gpointer instance)
{
    g_object_unref (instance);
}

static PangoContext *
pangoft2_view_get_context (gpointer instance)
{
    return pango_font_map_create_context (PANGO_FONT_MAP (instance));
}

static gpointer
pangoft2_view_create_surface (gpointer instance G_GNUC_UNUSED,
                              int      width,
                              int      height)
{
    FT_Bitmap *bitmap;

    bitmap = g_slice_new (FT_Bitmap);
    bitmap->width = width;
    bitmap->pitch = (bitmap->width + 3) & ~3;
    bitmap->rows = height;
    bitmap->buffer = g_malloc (bitmap->pitch * bitmap->rows);
    bitmap->num_grays = 256;
    bitmap->pixel_mode = ft_pixel_mode_grays;
    memset (bitmap->buffer, 0x00, bitmap->pitch * bitmap->rows);

    return bitmap;
}

static void
pangoft2_view_destroy_surface (gpointer instance G_GNUC_UNUSED,
                               gpointer surface)
{
    FT_Bitmap *bitmap = (FT_Bitmap *) surface;

    g_free (bitmap->buffer);
    g_slice_free (FT_Bitmap, bitmap);
}

static void
render_callback (PangoLayout *layout,
                 int          x,
                 int          y,
                 gpointer     context,
                 gpointer     state G_GNUC_UNUSED)
{
    pango_ft2_render_layout ((FT_Bitmap *)context,
                             layout,
                             x, y);
}

static void
pangoft2_view_render (gpointer      instance G_GNUC_UNUSED,
                      gpointer      surface,
                      PangoContext *context,
                      int          *width,
                      int          *height,
                      gpointer      state)
{
    int pix_idx;
    FT_Bitmap *bitmap = (FT_Bitmap *) surface;

    // do_output (context, render_callback, NULL, surface, state, width, height);

    pango_context_set_language (context, pango_language_get_default ());
    pango_context_set_base_dir (context, PANGO_DIRECTION_LTR);

    pango_context_set_base_gravity (context, opt_gravity);
    pango_context_set_gravity_hint (context, opt_gravity_hint);

    PangoLayout *layout;
    static PangoFontDescription *font_description;
    layout = pango_layout_new (context);
    pango_layout_set_text (layout, text, -1);
    font_description = pango_font_description_from_string (opt_font);
    pango_layout_set_font_description (layout, font_description);
    pango_font_description_free (font_description);

    *width = 0;
    *height = 0;

    PangoRectangle logical_rect;
    pango_layout_get_pixel_extents (layout, NULL, &logical_rect);

    render_callback(layout, 0, 0+*height, surface, state);

    *width = MAX (*width,
                  MAX (logical_rect.x + logical_rect.width,
                       PANGO_PIXELS (pango_layout_get_width (layout))));

    *height +=    MAX (logical_rect.y + logical_rect.height,
                       PANGO_PIXELS (pango_layout_get_height (layout)));

    for (pix_idx = 0; pix_idx < bitmap->pitch * bitmap->rows; pix_idx++)
        bitmap->buffer[pix_idx] = 255 - bitmap->buffer[pix_idx];
}

static void
pangoft2_view_write (gpointer instance G_GNUC_UNUSED,
                     gpointer surface,
                     FILE    *stream,
                     int      width,
                     int      height)
{
    int row, bytes;
    FT_Bitmap *bitmap = (FT_Bitmap *) surface;

    /* Write it as pgm to output */
    fprintf(stream,
            "P5\n"
            "%d %d\n"
            "255\n", width, height);
    for (row = 0; row < height; row++)
        bytes = fwrite(bitmap->buffer + row * bitmap->pitch, 1, width, stream);
}

const PangoViewer pangoft2_viewer = {
    "PangoFT2",
    "ft2",
    ".pgm",
    pangoft2_view_create,
    pangoft2_view_destroy,
    pangoft2_view_get_context,
    pangoft2_view_create_surface,
    pangoft2_view_destroy_surface,
    pangoft2_view_render,
    pangoft2_view_write,
    NULL,
    NULL,
    NULL
};
#if RENDER_STANDALONE
int
main (int    argc,
      char **argv)
{
    const PangoViewer *view = &pangoft2_viewer;
    gpointer instance;
    PangoContext *context;
    int run;
    int width, height;
    gpointer surface;

    g_type_init();
    g_set_prgname ("pango-view");
    setlocale (LC_ALL, "");
    // parse_options (argc, argv);


    g_assert (view->id);

    instance = view->create (view);
    context = view->get_context (instance);
    width = height = 1;
    surface = view->create_surface (instance, width, height);
    view->render (instance, surface, context, &width, &height, NULL);
    view->destroy_surface (instance, surface);
    printf("render: %dx%d\n", width, height);
    surface = view->create_surface (instance, width, height);
    for (run = 0; run < MAX(1, opt_runs); run++)
        view->render (instance, surface, context, &width, &height, NULL);

    if (opt_output) {
        if (!view->write)
            fail ("%s viewer backend does not support writing", view->name);
        else {
            FILE *stream;
            GPid pid = 0;

            if (view->write_suffix && g_str_has_suffix (opt_output, view->write_suffix)) {
                stream = g_fopen (opt_output, "wb");
                if (!stream)
                    fail ("Cannot open output file %s: %s\n",
                          opt_output, g_strerror (errno));
            } else {
                int fd;
                const gchar *convert_argv[4] = {"convert", "-", "%s"};
                GError *error;

                convert_argv[2] = opt_output;

                if (!g_spawn_async_with_pipes (NULL, (gchar **)(void*)convert_argv, NULL,
                                               G_SPAWN_DO_NOT_REAP_CHILD |
                                               G_SPAWN_SEARCH_PATH |
                                               G_SPAWN_STDOUT_TO_DEV_NULL |
                                               G_SPAWN_STDERR_TO_DEV_NULL,
                                               NULL, NULL, &pid, &fd, NULL, NULL, &error))
                    fail ("When running ImageMagick 'convert' command: %s\n", error->message);
                stream = fdopen (fd, "wb");
            }
            view->write (instance, surface, stream, width, height);
            fclose (stream);
#ifdef G_OS_UNIX
            if (pid)
                waitpid (pid, NULL, 0);
#endif
        }
    }

    view->destroy_surface (instance, surface);
    g_object_unref (context);
    view->destroy (instance);
    // finalize ();
    return 0;
}
#endif