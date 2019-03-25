require File.expand_path("../lib/browser_sniffer/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name = "browser_sniffer"
  spec.version = BrowserSniffer::VERSION
  spec.authors = ["Shopify"]
  spec.email = ["gems@shopify.com"]
  spec.description = "Parses user agent strings and boils it all down to a few simple classifications."
  spec.summary = "Parses user agent strings and boils it all down to a few simple classifications."
  spec.homepage = "https://github.com/Shopify/browser_sniffer"
  spec.licenses = %W[GPLv2 MIT]

  spec.files = `git ls-files`.split("\n")
  spec.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9.3"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rake"
end
