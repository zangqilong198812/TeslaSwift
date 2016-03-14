[![Build Status](https://travis-ci.org/jonasman/TeslaSwift.svg?branch=master)](https://travis-ci.org/jonasman/TeslaSwift)
# TeslaSwift
Swift library to access the Tesla Model S API base on [Unofficial Tesla Model S API](http://docs.timdorr.apiary.io/#)

Installation
============

####Manual

Copy `Sources` folder into your project

####CocoaPods
```ruby
	pod 'TeslaSwift'
```
####Swift Package Manager
You can use [Swift Package Manager](https://swift.org/package-manager/) and specify a dependency in `Package.swift` by adding this:
```swift
.Package(url: "https://github.com/jonasman/TeslaSwift.git", majorVersion: 1)
```

Note: The dependencies are not yet SPM ready!

Usage
============
Import the module
```swift
	import TeslaSwift
```

Perform an authentication with your My Tesla credentials: 
```swift 
TeslaSwift.defaultInstance.authenticate(email, password: password)
```
Use the future to check the success: 
```swift 
.andThen { (result) -> Void in
					
					switch result {
					case .Success(_):
						//LogedIn!
					case .Failure(let error):
						print("Error: \(error as NSError)")
					}
					
				}
```


Example
===========
```swift

class ViewController {

  func showCars() {

    TeslaSwift.defaultInstance.getVehicles().andThen { 
      (results) -> Void in
			
			switch results {
			case .Success(let response):
				self.data = response
				self.tableView.reloadData()
			case .Failure(_): break
			}
			
		}
	
  }
}
```    

Options
============
You can use the mock server by setting: `TeslaSwift.defaultInstance.useMockServer = true`

Other Features
============
After the authentication is done. The library manages itself the access token. 
When the token expires the library will perform another authentication with your past credentials.

TODO
============
The library is still under development.

The api is much bigger and it will take some time until i get to the 1.0 version.
Library design might change. The Futures library and Alamonfire might change to other libraries or removed.

Licence
============
        
The MIT License (MIT)

Copyright (c) 2016 João Nunes

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
