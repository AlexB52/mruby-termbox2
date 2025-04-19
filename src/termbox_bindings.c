#include <mruby.h>
#include <mruby/compile.h>
#include <termbox2.h>

static mrb_value mrb_mruby_hello_world(mrb_state* mrb, mrb_value self) {
  return mrb_load_string(mrb, "puts 'Hello , World!'");
}

void mrb_mruby_termbox2_gem_init(mrb_state* mrb) {
  struct RClass* module = mrb_define_module(mrb, "Termbox2");
  mrb_define_class_method(mrb, module, "hello_world", mrb_mruby_hello_world,
                          MRB_ARGS_NONE());
}

void mrb_mruby_termbox2_gem_final(mrb_state* mrb) {}