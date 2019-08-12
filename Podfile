platform :macos, '10.14'

target 'analyze' do
  # archive
  pod 'SourcererArchiver', :git => 'https://github.com/hectr/swift-sourcerer.git'
  # unarchive
  pod 'SourcererUnarchiver', :git => 'https://github.com/hectr/swift-sourcerer.git'
  pod 'SourceryRuntime', :git => 'https://github.com/hectr/swift-sourcerer.git'
  # sourcery
  pod 'Sourcery'
  # swift types
  pod 'SwiftTypes', :path => '.', :testspecs => ['Tests']
  pod 'SwiftTypesMappers', :path => '.', :testspecs => ['Tests']
  pod 'SwiftFeature', :path => '.', :testspecs => ['Tests'] 
  # swiftlint
  pod 'SwiftLint'
end
