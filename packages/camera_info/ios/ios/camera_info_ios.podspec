Pod::Spec.new do |s|
  s.name             = 'camera_info_ios'
  s.version          = '0.1.0'
  s.summary          = 'iOS implementation of camera_info plugin'
  s.description      = <<-DESC
  iOS implementation for retrieving camera hardware information
                       DESC
  s.homepage         = 'https://github.com/your-org/camera_info'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Name' => 'your.email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end