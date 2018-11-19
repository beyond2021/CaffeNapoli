# Uncomment the next line to define a global platform for your project
 platform :ios, '10.0'

target 'CaffeNapoli' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

  # Pods for CaffeNapoli
pod ‘Firebase/Auth’
pod ‘Firebase/Database’
pod ‘Firebase/Storage’
pod 'Firebase/Messaging'
pod 'Firebase/Core'
pod 'lottie-ios'
pod 'HCSStarRatingView', '~> 1.5'
pod 'Stripe'
pod 'Alamofire', '~> 4.5'

pod 'GoogleSignIn'
pod 'Fabric'
pod 'Crashlytics'

pod 'FirebaseAuth'

pod 'Firebase'

pod 'TwitterCore'
pod 'FirebaseUI', '~> 4.0'
pod 'Bolts', :modular_headers => true, :inhibit_warnings => true
pod 'FacebookCore', :inhibit_warnings => true
pod 'FacebookLogin', :inhibit_warnings => true
pod 'FacebookShare', :inhibit_warnings => true
pod 'FBSDKCoreKit', :modular_headers => true, :inhibit_warnings => true
pod 'FBSDKLoginKit', :modular_headers => true, :inhibit_warnings => true
pod 'FBSDKShareKit', :modular_headers => true, :inhibit_warnings => true
pod 'NVActivityIndicatorView'
pod 'ESTabBarController-swift'
pod 'pop', '~> 1.0'
pod 'CCZoomTransition', '~> 0.1'
pod 'StatefulViewController', '~> 3.0'
pod 'TransitionButton'
pod 'EasyAnimation'



post_install do |installer|
installer.pods_project.targets.each do |target|
target.build_configurations.each do |config|
config.build_settings['CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF'] = 'NO'
end
end
end


end
