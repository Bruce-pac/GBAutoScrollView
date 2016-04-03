
Pod::Spec.new do |s|

  s.name         = 'NotBadScrollView'
  s.version      = '0.0.1'
  s.summary      = 'This is an auto scrollview assembly'

  s.description  = <<-DESC
                     This project implements the automatic cyclical playback picture functions, and simple to use.
                   DESC

    s.homepage     = 'https://github.com/Bruce-pac/NotBadScrollView'

    s.license      = "MIT"
    s.author       = { "Bruce-pac" => "Bruce_pac@foxmail.com" }
    s.platform     = :ios

    s.source       = { :git => "https://github.com/Bruce-pac/NotBadScrollView.git", :tag => "0.0.1" }

   s.source_files  =  "NotBadScrollView/NotBadScrollView/**"
   s.framework  = "UIKit"
   s.requires_arc = true

end
