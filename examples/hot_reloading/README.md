## To compile

Make sure to have mruby with termbox2 built first then compile the program with

```bash
# 1) build
../../bin/build clean all

# 2) compile the program
gcc -std=c99 -I../../mruby/include program.c -o matrix ../../mruby/build/host/lib/libmruby.a -lm

# 3) launch the program
./matrix

# 4) You can then change the `matrix.rb` file in the folder and see the changes reloaded. 
```

**ONLY SUPPORTS VALID RUBY CODE!** This is an example, and if the Ruby code isn't valid everything is blowing up.