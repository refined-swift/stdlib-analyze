Pod::Spec.new do |s|
    s.name             = 'SwiftTypes'
    s.version          = '0.1.0'
    s.summary          = s.name.to_s
    s.homepage         = 'https://github.com/refined-swift/stdlib-analyze'
    s.author           = { 'Hèctor Marquès' => 'h@mrhector.me' }
    s.license          = { :type => 'MIT' }
    s.swift_version    = '5.0'
    s.osx.deployment_target = '10.14'
    s.source           = { :git => 'https://github.com/refined-swift/stdlib-analyze' }
    s.source_files     = ['Sources/SwiftTypes/**/*']
    s.test_spec 'Tests' do |test_spec|
      test_spec.source_files = 'Tests/SwiftTypesTests/**/*'
    end
end
