#
# Be sure to run `pod lib lint iBotSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'iBotSDK'
  s.version          = '0.0.11'
  s.summary          = 'iBotSDK for iOS'

  
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!


  s.description      = 'iBotSDK for iOS \O_O/'

  s.homepage         = 'http://brand.istore.camp/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'enliple' => 'ibot@enliple.com' }
  s.source           = { :git => 'https://github.com/enliple-ibot/iBotSDK_iOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = '4.0'
  
  s.source_files = 'iBotSDK/Classes/**/*'
  
  s.resource_bundles = {
     'iBotSDK' => ['iBotSDK/Assets/**/*',
                   'iBotSDK/Classes/**/*.xib']
  }


end
