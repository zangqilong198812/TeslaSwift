Pod::Spec.new do |s|
	s.name         = "TeslaSwift"
	s.version      = "5.0.0"
	s.summary      = "Swift library to access the Tesla Model S API."

	s.homepage     = "https://github.com/jonasman/TeslaSwift"

	s.license      = { :type => "MIT", :file => "LICENSE" }

	s.author             = { "Joao Nunes" => "joao3001@hotmail.com" }
	s.social_media_url   = "https://twitter.com/jonas2man"
	s.ios.deployment_target = '10.0'
	s.osx.deployment_target = '10.12'
	s.watchos.deployment_target = '3.0'
	s.tvos.deployment_target = '10.0'
	s.swift_version = '5'

	s.source       = { :git => "https://github.com/jonasman/TeslaSwift.git", :tag => "#{s.version}" }

	s.source_files  = "Sources/*.swift"


	s.framework  = "Foundation"

	s.requires_arc = true

    s.subspec 'PromiseKit' do |ss|
        ss.ios.source_files = ss.osx.source_files = 'Extensions/PromiseKit/*'
        ss.dependency 'PromiseKit/CorePromise' ,  '~> 6'
        ss.ios.deployment_target = '10.0'
        ss.osx.deployment_target = '10.12'
end

end
