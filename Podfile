platform :macos, '10.14'

target 'analyze' do
  # tools
  pod 'Sourcery'
  pod 'SwiftLint'
  # sourcerer
  pod 'SourcererArchiver', :git => 'https://github.com/hectr/swift-sourcerer.git'
  pod 'SourcererUnarchiver', :git => 'https://github.com/hectr/swift-sourcerer.git'
  pod 'SourceryRuntime', :git => 'https://github.com/hectr/swift-sourcerer.git'
  # std-lib analysis
  pod 'SwiftTypes', :path => '.', :testspecs => ['Tests']
  pod 'SwiftTypesMappers', :path => '.', :testspecs => ['Tests']
  pod 'SwiftFeature', :path => '.', :testspecs => ['Tests']
  pod 'SwiftWrappable', :path => '.', :testspecs => ['Tests']
end
