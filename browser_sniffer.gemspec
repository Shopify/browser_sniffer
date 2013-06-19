require File.expand_path("../.gemspec", __FILE__)
require File.expand_path("../lib/browser_sniffer/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name = "browser_sniffer"
  spec.version = BrowserSniffer::VERSION
  spec.authors = ["Shopify"]
  spec.email = ["gems@shopify.com"]
  spec.description = readme.description
  spec.summary = readme.summary
  spec.homepage = "https://github.com/Shopify/browser_sniffer"
  spec.license = "GPLv2 & MIT"

  spec.files = files
  spec.executables = files.executables
  spec.test_files = files.tests
  spec.require_paths = files.requires

  spec.required_ruby_version = ">= 1.9.3"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end