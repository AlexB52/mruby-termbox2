MRuby::Build.new do |conf|
  toolchain :gcc

  conf.cc.defines << 'MRB_UTF8_STRING'
  conf.gem "#{ MRUBY_ROOT }/.."
  conf.gembox 'default'
end
