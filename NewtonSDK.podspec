Pod::Spec.new do |s|
  s.name             = 'NewtonSDK'
  s.version          = '0.0.1'
  s.summary          = 'Newton SDK for iOS.'

  s.homepage         = 'https://github.com/newton-technology/newton-ios-sdk'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  # s.license          = { :type => 'Apache', :file => 'LICENSE' }
  s.authors          = 'Newton Technology'
  s.source           = { :git => 'https://github.com/newton-technology/newton-ios-sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  
  s.subspec 'NewtonAuth' do |ss|
    ss.ios.deployment_target = '10.0'
  end
end
