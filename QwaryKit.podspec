

Pod::Spec.new do |s|
  s.name             = 'QwaryKit'
  s.version          = '2.0.0'
  s.summary          = 'An SDK to configure the Survey on customising Screen where the user can'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                       The Qwary iOS SDK allows you to seamlessly integrate surveys and feedback forms into your iOS application.
                       DESC
  s.homepage         = 'https://www.qwary.com/'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Qwary Team' => 'Support@qwary.com' }
  s.source           = { :git => 'https://github.com/Qwary-team/QwaryKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '14.0'
  s.swift_version    = '5.0'
  s.source_files = 'Classes/**/*'
  s.resources    = 'Classes/**/*.{html}'
  # s.resource_bundles = {
  #   'QwaryKit' => ['QwaryKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
