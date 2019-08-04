Pod::Spec.new do |s|
  s.name             = "BabyFirstDataBinder"
  s.version           = '1.0.2'
  s.summary          = "BabyFirstDataBinder"
  s.description      = <<-DESC
                        BabyFirstDataBinder container.
                       DESC
  s.homepage         = "https://github.com/applicaster-plugins/BabyFirstDataBinder-iOS"
  s.license          = ''
  s.author           = { "cmps" => "a=m.vecselboim@applicaster.com" }
  s.source           = { :git => "git@github.com:applicaster-plugins/BabyFirstDataBinder-iOS.git", :tag => s.version.to_s }

  s.platform                = :ios, '10.0'
  s.ios.deployment_target   = "10.0"
  s.requires_arc            = true
  s.static_framework        = true
  s.swift_version           = '4.1'

  s.source_files = 'PluginClasses/**/*.{swift}'

  s.xcconfig =  { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                  'ENABLE_BITCODE' => 'YES',
                  'SWIFT_VERSION' => '5.0'
              }

  s.dependency 'ApplicasterSDK'
  s.dependency 'ComponentsSDK'
  s.dependency 'ZappGeneralPluginsSDK'
  s.dependency 'ZappPlugins'

end
