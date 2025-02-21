require 'json'

folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'
fabric_enabled = ENV['RCT_NEW_ARCH_ENABLED'] == '1'

Pod::Spec.new do |s|
  s.name         = "VideoModule"
  s.version      = "1.0.0"
  s.summary      = "Video Module for React Native"
  s.description  = "Video playback support for React Native applications"
  s.homepage     = "https://github.com/jab-r/loxation"
  s.license      = "MIT"
  s.author       = { "Jonathan Borden" => "jonathan@openhealth.org" }
  s.platform     = :ios, "13.0"
  s.source       = { :git => "https://github.com/jab-r/loxation.git", :tag => "#{s.version}" }

  s.source_files = ["ios/**/*.{h,m,mm,swift}", "ios/Fabric/**/*.{h,m,mm}"]
  s.header_dir = "VideoModule"
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'SWIFT_COMPILATION_MODE' => 'wholemodule'
  }
  s.requires_arc = true

  # Video playback dependencies
  s.framework = "AVFoundation"
  s.framework = "AVKit"
  s.framework = "CoreMedia"
  
  # Optional: Add caching support
  s.dependency "Cache", "~> 6.0.0"

  # Use install_modules_dependencies helper to install the dependencies if React Native version >=0.71.0.
  if respond_to?(:install_modules_dependencies, true)
    install_modules_dependencies(s)
  else
    s.dependency "React-Core"

    # Don't install the dependencies when we run `pod install` in the old architecture.
    if fabric_enabled
      s.compiler_flags = folly_compiler_flags + " -DRCT_NEW_ARCH_ENABLED=1"
      s.pod_target_xcconfig.merge!({
        "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\"",
        "OTHER_CPLUSPLUSFLAGS" => "-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1",
        "CLANG_CXX_LANGUAGE_STANDARD" => "c++17"
      })
      s.dependency "React-RCTFabric"
      s.dependency "React-Codegen"
      s.dependency "RCT-Folly"
      s.dependency "RCTRequired"
      s.dependency "RCTTypeSafety"
      s.dependency "ReactCommon/turbomodule/core"
    end
  end
end
