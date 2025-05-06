#define TB_IMPL

#include <locale.h>
#include <mruby.h>
#include <mruby/compile.h>
#include <mruby/hash.h>
#include <mruby/variable.h>
#include <termbox2.h>

static mrb_value mrb_tb2_init() {
  setlocale(LC_ALL, "");
  return mrb_fixnum_value(tb_init());
}

static mrb_value mrb_tb2_init_rwfd(mrb_state* mrb, mrb_value self) {
  mrb_int rfd, wfd;
  mrb_get_args(mrb, "ii", &rfd, &wfd);
  return mrb_fixnum_value(tb_init_rwfd(rfd, wfd));
}

static mrb_value mrb_tb2_shutdown() {
  return mrb_fixnum_value(tb_shutdown());
}

static mrb_value mrb_tb2_width() {
  return mrb_fixnum_value(tb_width());
}

static mrb_value mrb_tb2_height() {
  return mrb_fixnum_value(tb_height());
}

static mrb_value mrb_tb2_present() {
  return mrb_fixnum_value(tb_present());
}

static mrb_value mrb_tb2_clear() {
  return mrb_fixnum_value(tb_clear());
}

static mrb_value mrb_tb2_hide_cursor() {
  return mrb_fixnum_value(tb_hide_cursor());
}

static mrb_value mrb_tb2_set_cursor(mrb_state* mrb, mrb_value self) {
  mrb_int x, y;
  mrb_get_args(mrb, "ii", &x, &y);
  return mrb_fixnum_value(tb_set_cursor(x, y));
}

static mrb_value mrb_tb2_print(mrb_state* mrb, mrb_value self) {
  mrb_int x, y, fg, bg;
  const char* text;
  mrb_get_args(mrb, "iiiiz", &x, &y, &fg, &bg, &text);
  return mrb_fixnum_value(tb_print(x, y, fg, bg, text));
}

static mrb_value mrb_tb2_set_cell(mrb_state* mrb, mrb_value self) {
  mrb_int x, y, c, fg, bg;
  mrb_get_args(mrb, "iiiii", &x, &y, &fg, &bg, &c);
  return mrb_fixnum_value(tb_set_cell(x, y, c, fg, bg));
}

static mrb_value mrb_tb2_event_to_hash(mrb_state* mrb,
                                       const struct tb_event* ev) {
  mrb_value hash = mrb_hash_new_capa(mrb, 8);

  mrb_hash_set(mrb, hash, mrb_symbol_value(mrb_intern_lit(mrb, "type")),
               mrb_fixnum_value(ev->type));
  mrb_hash_set(mrb, hash, mrb_symbol_value(mrb_intern_lit(mrb, "key")),
               mrb_fixnum_value(ev->key));
  mrb_hash_set(mrb, hash, mrb_symbol_value(mrb_intern_lit(mrb, "ch")),
               mrb_fixnum_value(ev->ch));
  mrb_hash_set(mrb, hash, mrb_symbol_value(mrb_intern_lit(mrb, "mod")),
               mrb_fixnum_value(ev->mod));
  mrb_hash_set(mrb, hash, mrb_symbol_value(mrb_intern_lit(mrb, "x")),
               mrb_fixnum_value(ev->x));
  mrb_hash_set(mrb, hash, mrb_symbol_value(mrb_intern_lit(mrb, "y")),
               mrb_fixnum_value(ev->y));
  mrb_hash_set(mrb, hash, mrb_symbol_value(mrb_intern_lit(mrb, "w")),
               mrb_fixnum_value(ev->w));
  mrb_hash_set(mrb, hash, mrb_symbol_value(mrb_intern_lit(mrb, "h")),
               mrb_fixnum_value(ev->h));

  return hash;
}

static mrb_value mrb_tb2_poll_event(mrb_state* mrb, mrb_value self) {
  struct tb_event ev;
  int rc = tb_poll_event(&ev);
  if (rc < 0) {
    return mrb_nil_value();
  }

  return mrb_tb2_event_to_hash(mrb, &ev);
}

static mrb_value mrb_tb2_peek_event(mrb_state* mrb, mrb_value self) {
  struct tb_event ev;
  mrb_int timeout;
  mrb_get_args(mrb, "i", &timeout);
  int rc = tb_peek_event(&ev, timeout);
  if (rc < 0) {
    return mrb_nil_value();
  }

  return mrb_tb2_event_to_hash(mrb, &ev);
}

static mrb_value mrb_mruby_hello_world(mrb_state* mrb, mrb_value self) {
  return mrb_load_string(mrb, "puts 'Hello , World!'");
}

static mrb_value mrb_tb2_set_input_mode(mrb_state* mrb, mrb_value self) {
  mrb_int mode;
  mrb_get_args(mrb, "i", &mode);
  return mrb_fixnum_value(tb_set_input_mode((int)mode));
}

void mrb_mruby_termbox2_gem_init(mrb_state* mrb) {
  struct RClass* module = mrb_define_module(mrb, "Termbox2");

  mrb_define_module_function(mrb, module, "hello_world", mrb_mruby_hello_world,
                             MRB_ARGS_NONE());

  mrb_define_module_function(mrb, module, "init", mrb_tb2_init,
                             MRB_ARGS_NONE());
  mrb_define_module_function(mrb, module, "init_rwfd", mrb_tb2_init_rwfd,
                             MRB_ARGS_REQ(2));
  mrb_define_module_function(mrb, module, "shutdown", mrb_tb2_shutdown,
                             MRB_ARGS_NONE());
  mrb_define_module_function(mrb, module, "width", mrb_tb2_width,
                             MRB_ARGS_NONE());
  mrb_define_module_function(mrb, module, "height", mrb_tb2_height,
                             MRB_ARGS_NONE());
  mrb_define_module_function(mrb, module, "present", mrb_tb2_present,
                             MRB_ARGS_NONE());
  mrb_define_module_function(mrb, module, "clear", mrb_tb2_clear,
                             MRB_ARGS_NONE());
  mrb_define_module_function(mrb, module, "print", mrb_tb2_print,
                             MRB_ARGS_REQ(5));
  mrb_define_module_function(mrb, module, "poll_event", mrb_tb2_poll_event,
                             MRB_ARGS_NONE());
  mrb_define_module_function(mrb, module, "peek_event", mrb_tb2_peek_event,
                             MRB_ARGS_REQ(1));
  mrb_define_module_function(mrb, module, "set_cursor", mrb_tb2_set_cursor,
                             MRB_ARGS_REQ(2));
  mrb_define_module_function(mrb, module, "hide_cursor", mrb_tb2_hide_cursor,
                             MRB_ARGS_NONE());
  mrb_define_module_function(mrb, module, "set_native_input_mode",
                             mrb_tb2_set_input_mode, MRB_ARGS_REQ(1));
  mrb_define_module_function(mrb, module, "set_cell", mrb_tb2_set_cell,
                             MRB_ARGS_REQ(5));
}

void mrb_mruby_termbox2_gem_final(mrb_state* mrb) {
  tb_shutdown();
}