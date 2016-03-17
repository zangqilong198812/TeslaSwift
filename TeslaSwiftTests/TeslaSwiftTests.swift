//
//  TeslaSwiftTests.swift
//  TeslaSwiftTests
//
//  Created by Joao Nunes on 04/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import XCTest
@testable import TeslaSwift
import Mockingjay

class TeslaSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("Authentication", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Authentication.path), builder: jsonData(data))
		
		let path2 = NSBundle(forClass: self.dynamicType).pathForResource("Vehicles", ofType: "json")!
		let data2 = NSData(contentsOfFile: path2)!
		stub(uri(Endpoint.Vehicles.path), builder: jsonData(data2))
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
			case .Success(let response):
				XCTAssertEqual(response.accessToken, "abc123-mock")
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
				case .Success(let response):
					XCTAssertEqual(response[0].displayName, "mockCar")
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
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("MobileAccess", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.MobileAccess(vehicleID: 1234567890).path), builder: jsonData(data))
		let path2 = NSBundle(forClass: self.dynamicType).pathForResource("ChargeState", ofType: "json")!
		let data2 = NSData(contentsOfFile: path2)!
		stub(uri(Endpoint.ChargeState(vehicleID: 1234567890).path), builder: jsonData(data2))
		let path3 = NSBundle(forClass: self.dynamicType).pathForResource("ClimateSettings", ofType: "json")!
		let data3 = NSData(contentsOfFile: path3)!
		stub(uri(Endpoint.ClimateState(vehicleID: 1234567890).path), builder: jsonData(data3))
		let path4 = NSBundle(forClass: self.dynamicType).pathForResource("DriveState", ofType: "json")!
		let data4 = NSData(contentsOfFile: path4)!
		stub(uri(Endpoint.DriveState(vehicleID: 1234567890).path), builder: jsonData(data4))
		let path5 = NSBundle(forClass: self.dynamicType).pathForResource("GuiSettings", ofType: "json")!
		let data5 = NSData(contentsOfFile: path5)!
		stub(uri(Endpoint.GuiSettings(vehicleID: 1234567890).path), builder: jsonData(data5))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").flatMap { (token) in
			service.getVehicles()
			}.flatMap { (vehicles)  in
				service.getVehicleStatus(vehicles[0])
			}.andThen { (result) -> Void in
				switch result {
				case .Success(let response):
					XCTAssertEqual(response.mobileAccess, false)
					XCTAssertEqual(response.chargeState?.chargingState, .Complete)
					XCTAssertEqual(response.chargeState?.batteryRange?.miles, 200.0)
					XCTAssertEqual(response.climateState?.insideTemperature?.celsius,18.0)
					XCTAssertEqual(response.driveState?.position?.course,10.0)
					XCTAssertEqual(response.guiSettings?.distanceUnits,"km/hr")
				case .Failure(let error):
					print(error)
					XCTFail((error as NSError).description)
				}
				expection.fulfill()
		}
		
		waitForExpectationsWithTimeout(5, handler: nil)
		
	}
    
}
