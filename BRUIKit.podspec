Pod::Spec.new do |s|
  s.name         = "BRUIKit"
  s.version      = "1.0.1"
  s.summary      = "iOS library"
  s.homepage     = "https://github.com/ElieMelki"
  s.author       = { "Elie Melki" => "elie.j.melki@gmail.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/ElieMelki/BRUIKit.git" , :tag => s.version }
  s.source_files =  'BRUIKit/BRUIKit/Classes/**/*.swift'
  s.swift_versions = '5.0'
  s.ios.deployment_target = '9.0'
  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true
  s.license      = {
    :type => 'Copyright',
    :text => <<-LICENSE
      Copyright 2014-2015 Elie Melki. All rights reserved.
      LICENSE
  }
end
