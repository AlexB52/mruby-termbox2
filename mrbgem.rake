MRuby::Gem::Specification.new('mruby-termbox2') do |spec|
  spec.license  = 'MIT'
  spec.author   = 'Alexandre Barret'
  spec.summary  = 'mruby bindings for termbox2'

  spec.cc.include_paths << File.join(__dir__, 'termbox2')
end
