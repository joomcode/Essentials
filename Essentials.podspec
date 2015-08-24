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
  
  s.requires_arc = true
  
  s.dependency "Masonry", "~> 0.5"

  s.subspec 'Basic' do |ss|
    ss.source_files = "Essentials/Basic/**/*.{h,m}"
  end

  s.subspec 'Fancy' do |ss|
    ss.source_files = "Essentials/Fancy/**/*.{h,m}"    
  end

  s.default_subspec = 'Basic'
end
