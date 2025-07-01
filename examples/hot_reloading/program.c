#include <mruby.h>
#include <mruby/compile.h>
#include <mruby/string.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

time_t get_mtime(const char* path) {
  struct stat st;
  return stat(path, &st) == 0 ? st.st_mtime : 0;
}

void load_script(mrb_state* mrb, const char* path) {
  FILE* fp = fopen(path, "r");
  if (!fp) {
    perror("fopen");
    return;
  }
  mrb_load_file(mrb, fp);
  fclose(fp);
}

int main() {
  const char* script_path = "matrix.rb";
  time_t last_mtime = 0;

  mrb_state* mrb = mrb_open();
  if (!mrb) {
    fprintf(stderr, "mruby init failed\n");
    return 1;
  }

  // Initial load
  load_script(mrb, script_path);
  last_mtime = get_mtime(script_path);

  mrb_funcall(mrb, mrb_top_self(mrb), "setup", 0);

  for (;;) {
    // Check for reload
    time_t mtime = get_mtime(script_path);
    if (mtime > last_mtime) {
      mrb->exc = 0;
      load_script(mrb, script_path);
      last_mtime = mtime;
    }

    // tick()
    mrb_funcall(mrb, mrb_top_self(mrb), "tick", 0);
    if (mrb->exc) {
      mrb_print_error(mrb);
      mrb->exc = 0;
      mrb_load_string(mrb, "TB2.shutdown");
      mrb_close(mrb);
      return 0;
    }
  }

  mrb_close(mrb);
  return 0;
}
