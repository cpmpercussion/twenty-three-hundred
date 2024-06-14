source "https://rubygems.org"

gem "jekyll", "~> 4.3.3"

group :jekyll_plugins do
  gem "monophase", :git => "https://github.com/cpmpercussion/monophase.git", :branch => "main" 
  gem "jekyll-feed", "~> 0.12"
  gem "jekyll-revealify-plugin", :git => "git@gitlab.anu.edu.au:u4110680/jekyll-revealify-plugin.git", :ref => '808c4a48'
  gem 'jekyll-fontawesome-svg'
end

platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", :platforms => [:mingw, :x64_mingw, :mswin]

# Lock `http_parser.rb` gem to `v0.6.x` on JRuby builds since newer versions of the gem
# do not have a Java counterpart.
gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]