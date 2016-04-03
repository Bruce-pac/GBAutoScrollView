
Pod::Spec.new do |s|


  s.name         = "NotBadScrollView"
  s.version      = "0.0.1"
  s.summary      = "This is a UI assembly that can automatically scroll pictures"

  s.homepage     = "https://github.com/Bruce-pac/NotBadScrollView"

  s.license      = "MIT"

  s.author             = { "Bruce-pac" => "Bruce-pac@foxmail.com" }

  s.platform     = :ios, "8.0"

  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/Bruce-pac/NotBadScrollView.git", :commit => "4cd855bb3b7172e5ca74265f8dd89e737cf35498" }

  s.source_files  = "NotBadScrollView/*.{h,m}"

  s.resource  = "NotBadScrollView/placeholder.png"

  s.framework  = "UIKit"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

end
