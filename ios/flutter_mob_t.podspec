#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_mob_t'
  s.version          = '0.0.3'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'https://github.com/tanhuang/flutter_mob_t.git'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'tanhuang' => '421526639@qq.com' }
  s.source           = { :git =>  'https://github.com/tanhuang/flutter_mob_t.git', :tag => "#{s.version}" }
  s.source_files = 'ios/Classes/*.{h,m}'
  s.dependency 'Flutter'
  s.dependency 'mob_smssdk'
  s.dependency 'mob_sharesdk'
  s.ios.deployment_target = '9.0'
  s.xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64' }
end

