#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_mob_t'
  s.version          = '0.0.2'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'mobsms'
  s.dependency 'mob_sharesdk'
  # s.dependency 'mob_sharesdk/ShareSDKUI'
  # s.dependency 'mob_sharesdk/ShareSDKPlatforms/WeChat'
  # s.dependency 'mob_sharesdk/ShareSDKPlatforms/QQ'
  # s.dependency 'mob_sharesdk/ShareSDKPlatforms/SinaWeibo'
  s.ios.deployment_target = '9.0'
end

