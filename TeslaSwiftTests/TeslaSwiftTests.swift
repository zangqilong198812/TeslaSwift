//
//  TeslaSwiftTests.swift
//  TeslaSwiftTests
//
//  Created by Joao Nunes on 04/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import XCTest
@testable import TeslaSwift

class TeslaSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAuthenticate() {
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true

		service.authenticate("user", password: "pass").andThen { (result) -> Void in
			
			switch result {
			case .Success(_):
				break
			case .Failure(let error):
				print(error)
			}
			expection.fulfill()
		}

		waitForExpectationsWithTimeout(5, handler: nil)
		
    }
	
	func testReuseToken() {
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").andThen {
			(result) -> Void in
			
			service.checkToken().andThen { (result) -> Void in
				
				switch result {
				case .Success(let response):
					XCTAssertTrue(response.boolValue)
				case .Failure(let error):
					XCTFail("Token is not valid: \((error as NSError).description)")
				}
				
				expection.fulfill()
			}

		}
		
		waitForExpectationsWithTimeout(5, handler: nil)
		

	}
	
	func testGetVehicles() {
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").andThen {
			(result) -> Void in
			service.getVehicles().andThen {
				(result) -> Void in
				
				switch result {
				case .Success(_):
					break
				case .Failure(let error):
					print(error)
					XCTFail((error as NSError).description)
				}
				
				expection.fulfill()
				
			}
		}
		
		waitForExpectationsWithTimeout(5, handler: nil)
		
	}

	func testGetVehicleState() {
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").flatMap { (token) in
			service.getVehicles()
			}.flatMap { (vehicles)  in
				service.getVehicleStatus(vehicles[0])
			}.andThen { (result) -> Void in
				switch result {
				case .Success(_):
					break
				case .Failure(let error):
					print(error)
					XCTFail((error as NSError).description)
				}
				expection.fulfill()
		}
		
		waitForExpectationsWithTimeout(5, handler: nil)
		
	}
    
}
