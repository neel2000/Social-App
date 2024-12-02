# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SocialApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SocialApp
pod 'FirebaseAnalytics'
pod 'FirebaseMessaging'
pod 'ReachabilitySwift'
pod 'Alamofire'
pod 'SVProgressHUD'
pod 'IQKeyboardManagerSwift'
pod 'CropViewController'
pod 'PhoneNumberKit'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0' #set your minimum version your all pods will set to mininum 13.1 version :-)
    end
  end
end

end
