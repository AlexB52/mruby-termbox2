MRuby::Build.new do |conf|
  toolchain :gcc

  conf.gem "#{ MRUBY_ROOT }/.."
  conf.gembox 'default'
end
