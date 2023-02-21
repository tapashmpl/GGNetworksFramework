Pod::Spec.new do |s|
  s.name         = "GGNetworkFramework"
  s.version      = "1.0.0"
  s.license      = "MIT"
  s.platform     = :ios
  s.homepage     = 'https://github.com/tapashmpl/GGNetworksFramework'
  s.authors      = { 'Tapash Mollick' => 'tapashmollick@mplgaming.com' }
  s.summary      = "It's network library to help in network call"
  s.description      = <<-DESC
It's network library to help in network call. A kind of plugin play for all network call
DESC
  s.source       = { :git => 'https://github.com/tapashmpl/GGNetworksFramework.git', :tag => s.version }
  s.ios.deployment_target   = '11.0'
  s.swift_version           = '5.0'
 s.vendored_frameworks = "GGNetworkFramework.xcframework"
end