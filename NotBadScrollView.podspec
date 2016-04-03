

Pod::Spec.new do |s|

  s.name         = "NotBadScrollView"
  s.version      = "1.0.0"
  s.summary      = “This is an auto scrollview assembly"

  s.description  = <<-DESC
                     This project implements the automatic cyclical playback picture functions, and simple to use.
                   DESC

  s.homepage     = "https://github.com/Bruce-pac/NotBadScrollView"

    s.license      = "MIT"
  s.author             = { "Bruce-pac" => "Bruce-pac@foxmail.com" }
    s.platform     = :ios
  # s.platform     = :ios, "5.0"

  s.source       = { :git => "https://github.com/Bruce-pac/NotBadScrollView.git", :tag => "1.0.0" }

  s.source_files  =  "NotBadScrollView/NotBadScrollView/*"
  s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"
   s.framework  = "UIKit"
   s.requires_arc = true

end
