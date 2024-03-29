#
# Be sure to run `pod lib lint ATPayHandler.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name                    = 'ATPayHandler'
    s.version                 = '0.1.0'
    s.summary                 = 'Pay handler.'
    s.homepage                = 'https://github.com/ablettchen/ATPayHandler'
    s.license                 = { :type => 'MIT', :file => 'LICENSE' }
    s.author                  = { 'ablett' => 'ablett.chen@gmail.com' }
    s.source                  = { :git => 'https://github.com/ablettchen/ATPayHandler.git', :tag => s.version.to_s }
    s.social_media_url        = 'https://twitter.com/ablettchen'
    s.ios.deployment_target   = '8.0'
    s.source_files            = 'ATPayHandler/**/*.{h,m}'
    #s.resource                = 'ATPayHandler/ATPayHandler.bundle'
    s.requires_arc            = true
    
    s.dependency 'ATCategories'
    s.dependency 'AlipaySDK-iOS'
    s.dependency 'WechatOpenSDK'
    
end
