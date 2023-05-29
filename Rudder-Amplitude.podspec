require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

amplitude_sdk_version = '8.16.0' #We've fixed the version, as we are directly using the corresponding US and EU ENUMS integer value.
rudder_sdk_version = '~> 1.12'
deployment_target = '12.0'
amplitude_app_events = 'Amplitude'

Pod::Spec.new do |s|
  s.name             = 'Rudder-Amplitude'
  s.version          = package['version']
  s.summary          = 'Privacy and Security focused Segment-alternative. Firebase Native SDK integration support.'

  s.description      = <<-DESC
  Rudder is a platform for collecting, storing and routing customer event data to dozens of tools. Rudder is open-source, can run in your cloud environment (AWS, GCP, Azure or even your data-centre) and provides a powerful transformation framework to process your event data on the fly.
                       DESC
  s.homepage         = 'https://github.com/rudderlabs/rudder-integration-amplitude-ios'
  s.license          = { :type => "Apache", :file => "LICENSE.md" }
  s.author           = { 'RudderStack' => 'arnab@rudderstack.com' }
  s.platform         = :ios, "12.0"
  s.source           = { :git => 'https://github.com/rudderlabs/rudder-integration-amplitude-ios.git' , :tag => "v#{s.version}" }
  s.requires_arc        = true
  
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

  s.source_files = 'Rudder-Amplitude/Classes/**/*'

  s.ios.deployment_target = deployment_target
  
  if defined?($AmplitudeSDKVersion)
    amplitude_sdk_version = $AmplitudeSDKVersion
    Pod::UI.puts "#{s.name}: Using user specified Amplitude SDK version '#{AmplitudeSDKVersion}'"
  else
    Pod::UI.puts "#{s.name}: Using default amplitude SDK version '#{amplitude_sdk_version}'"
  end

  if defined?($RudderSDKVersion)
    Pod::UI.puts "#{s.name}: Using user specified Rudder SDK version '#{$RudderSDKVersion}'"
    rudder_sdk_version = $RudderSDKVersion
  else
    Pod::UI.puts "#{s.name}: Using default Rudder SDK version '#{rudder_sdk_version}'"
  end
  
  s.dependency 'Rudder', rudder_sdk_version
  s.dependency amplitude_app_events, amplitude_sdk_version
end
