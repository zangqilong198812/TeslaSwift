Pod::Spec.new do |s|
	s.name         = "TeslaSwift"
	s.version      = "1.0.0"
	s.summary      = "Swift library to access the Tesla Model S API."

	s.homepage     = "https://github.com/jonasman/TeslaSwift"

	s.license      = { :type => "MIT", :file => "LICENSE" }

	s.author             = { "Joao Nunes" => "joao3001@hotmail.com" }
	s.social_media_url   = "https://twitter.com/jonas2man"
	s.platform     = :ios, "8.0"

	s.source       = { :git => "https://github.com/jonasman/TeslaSwift.git", :tag => "1.0.0" }

	s.source_files  = "Sources/*.swift"


	s.framework  = "Foundation"

	s.requires_arc = true

	s.dependency "BrightFutures"
	s.dependency "Alamofire", "~> 3.0"
	s.dependency "AlamofireObjectMapper", "~> 2.1"

end
