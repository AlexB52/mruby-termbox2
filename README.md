# mruby-termbox2

Mruby bindings for the [termbox2 C library](https://github.com/termbox/termbox2)

## Dependencies
  
  * Ruby 3 (for testing and compilation)
  * GCC (for compilation)
  * Make sure to pull the git submodules as well

## Build

To build, you'll need to have mruby and termbox2 submodules pulled first before running the command.
This build will be for development and testing mode

    bin/build

## Run mruby code

To run mruby code, you need to build the mruby interpreter first with `bin/build`

    bin/run examples/hello_world.rb
 
## Testing

To run tests, you need to build the mruby interpreter first with `bin/build`

    bin/build
    bundle
    rake

## Compile and run demos as executable

    bin/compile -o my_programm demos/hello_world.rb
    ./my_program

The `bin/compile` will: 

  1. Build mruby for compilation
  2. Build the demo file in bytecode
  3. Wrap the demo bytecode in a c wrapper
  4. Compile the c wrapper for execution
