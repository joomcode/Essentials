Pod::Spec.new do |s|
  s.name         = "Essentials"
  s.version      = "0.0.1"
  s.summary      = "A bunch of stuff I can't live without."

  s.homepage     = "https://github.com/nickynick/Essentials"

  s.license      = "MIT"

  s.author           = { "Nick Tymchenko" => "t.nick.a@gmail.com" }
  s.social_media_url = "http://twitter.com/nickynick42"

  s.platform     = :ios, "7.0"
  
  s.source       = { :git => "https://github.com/nickynick/Essentials.git", :tag => "0.0.1" }

  s.source_files        = "Essentials/**/*.{h,m}"
  s.public_header_files = "Essentials/**/*.h"

  s.requires_arc = true
  
  s.dependency "Masonry", "~> 0.5"
end
