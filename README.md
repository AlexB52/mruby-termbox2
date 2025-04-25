# mruby-termbox2

Mruby bindings for the [termbox2 C library](https://github.com/termbox/termbox2)

## Build

To build, you'll need to have mruby and termbox2 submodules pulled first before running the command.

	bin/build

## Run mruby code

To run mruby code, you need to build the mruby interpreter first with `bin/build`

	bin/run examples/hello_world.rb
 
## Testing

To run tests, you need to build the mruby interpreter first with `bin/build`

	bin/build
	bundle
	rake
