MRuby::Build.new do |conf|
  toolchain :gcc

  conf.gem "#{ MRUBY_ROOT }/.."
  conf.gembox 'default'
  # conf.gembox 'full-core'

  conf.enable_debug
  conf.enable_bintest
  conf.enable_test
end
