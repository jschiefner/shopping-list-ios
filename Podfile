# Uncomment the next line to define a global platform for your project
platform :ios, '16.2'

target 'shopping-list-ios' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for shopping-list-ios
  
  pod 'Firebase/Core'
  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.2'
        config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
    end
    
    # installer.pods_project.build_configurations.each do |config|
    #   config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "x86_64"
    # end
  end
end
