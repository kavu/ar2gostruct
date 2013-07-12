# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ar2gostruct/version'

Gem::Specification.new do |spec|
  spec.name          = 'ar2gostruct'
  spec.version       = Ar2gostruct::VERSION
  spec.authors       = ['Tatsuo Kaniwa']
  spec.email         = ['tatsuo@kaniwa.biz']
  spec.description   = %q{Generate Go Struct from ActiveRecord models}
  spec.summary       = %q{Generate Go Struct from ActiveRecord models}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   << 'ar2gostruct'
  spec.require_paths = ['lib']
  spec.test_files    = spec.files.grep(%r{^spec/})

  spec.extra_rdoc_files = ['README.md']
  spec.rdoc_options     = ['--line-numbers', '--inline-source', '--title', 'ar2gostruct']

  spec.add_dependency 'rake'
  spec.add_dependency 'rails', '>= 2.3'
end
