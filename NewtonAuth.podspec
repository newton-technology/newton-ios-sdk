Pod::Spec.new do |s|
  s.name                    = 'NewtonAuth'
  s.version                 = '0.0.1'
  s.summary                 = 'Newton Authentication'
  s.homepage = 'https://nwtn.io/'
  s.source_files = [
    'NewtonAuth/Sources/*.swift',
  ]
  s.authors                 = 'Newton Technology'
  s.license          = { :type => 'Apache', :file => 'LICENSE' }
  s.source                  = {
    :git => 'https://github.com/newton-technology/newton-ios-sdk.git',
    :tag => 'CocoaPods-' + s.version.to_s
  }

  s.static_framework        = true
  s.swift_version           = '5.0'
  s.ios.deployment_target   = '10.0'

  s.cocoapods_version       = '>= 1.10.0'
  s.prefix_header_file      = false
  s.ios.dependency 'Alamofire'
end
