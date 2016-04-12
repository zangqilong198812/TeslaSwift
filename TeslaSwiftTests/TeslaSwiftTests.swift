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
		let path6 = NSBundle(forClass: self.dynamicType).pathForResource("VehicleState", ofType: "json")!
		let data6 = NSData(contentsOfFile: path6)!
		stub(uri(Endpoint.VehicleState(vehicleID: 1234567890).path), builder: jsonData(data6))
		
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
					XCTAssertEqual(response.vehicleState?.darkRims, true)
				case .Failure(let error):
					print(error)
					XCTFail((error as NSError).description)
				}
				expection.fulfill()
		}
		
		waitForExpectationsWithTimeout(5, handler: nil)
		
	}
	
	func testCommandWakeUp() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("WakeUp", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .WakeUp).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").flatMap { (token) in
			service.getVehicles()
			}.flatMap { (vehicles)  in
			service.sendCommandToVehicle(vehicles[0], command: .WakeUp)
			}.andThen { (result) -> Void in
		
				switch result {
				case .Success(let response):
					XCTAssertEqual(response.result, false)
					XCTAssertEqual(response.reason, "Test wakeup")
				case .Failure(let error):
					print(error)
					XCTFail((error as NSError).description)
				}
				expection.fulfill()
		}
		
		waitForExpectationsWithTimeout(5, handler: nil)
	}
	
	func testCommandValetMode() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("SetValetMode", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .ValetMode).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		let options = ValetCommandOptions(valetActivated: true, pin: "1234")
		
		service.authenticate("user", password: "pass").flatMap { (token) in
			service.getVehicles()
			}.flatMap { (vehicles) in
				service.sendCommandToVehicle(vehicles[0], command: .ValetMode, options: options)
			}.andThen { (result) -> Void in
				
				switch result {
				case .Success(let response):
					XCTAssertEqual(response.result, false)
					XCTAssertEqual(response.reason, "Test valet")
				case .Failure(let error):
					print(error)
					XCTFail((error as NSError).description)
				}
				expection.fulfill()
		}
		
		waitForExpectationsWithTimeout(5, handler: nil)
	}
	
	func testCommandValetModeNoOptions() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("SetValetMode", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .ValetMode).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").flatMap { (token) in
			service.getVehicles()
			}.flatMap { (vehicles) in
				service.sendCommandToVehicle(vehicles[0], command: .ValetMode, options: nil)
			}.andThen { (result) -> Void in
				
				switch result {
				case .Success(_):
					XCTFail("shoud not be success")
				case .Failure(let error):
					if case TeslaError.InvalidOptionsForCommand = error {
						//pass
					} else {
						XCTFail("wrong error")
					}
				}
				expection.fulfill()
		}
		
		waitForExpectationsWithTimeout(5, handler: nil)
	}
	
	func testCommandResetValetPin() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("ResetValetPin", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .ResetValetPin).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").flatMap { (token) in
			service.getVehicles()
			}.flatMap { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .ResetValetPin)
			}.andThen { (result) -> Void in
				
				switch result {
				case .Success(let response):
					XCTAssertEqual(response.result, false)
					XCTAssertEqual(response.reason, "Test resetValet")
				case .Failure(let error):
					print(error)
					XCTFail((error as NSError).description)
				}
				expection.fulfill()
		}
		
		waitForExpectationsWithTimeout(5, handler: nil)
	}
	
	func testCommandOpenChargePort() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("OpenChargeDoor", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .OpenChargeDoor).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").flatMap { (token) in
			service.getVehicles()
			}.flatMap { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .OpenChargeDoor)
			}.andThen { (result) -> Void in
				
				switch result {
				case .Success(let response):
					XCTAssertEqual(response.result, false)
					XCTAssertEqual(response.reason, "Test open charge door")
				case .Failure(let error):
					print(error)
					XCTFail((error as NSError).description)
				}
				expection.fulfill()
		}
		
		waitForExpectationsWithTimeout(5, handler: nil)
	}
	
	func testCommandChargeStandard() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("ChargeLimitStandard", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .ChargeLimitStandard).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").flatMap { (token) in
			service.getVehicles()
			}.flatMap { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .ChargeLimitStandard)
			}.andThen { (result) -> Void in
				
				switch result {
				case .Success(let response):
					XCTAssertEqual(response.result, false)
					XCTAssertEqual(response.reason, "Test charge standard")
				case .Failure(let error):
					print(error)
					XCTFail((error as NSError).description)
				}
				expection.fulfill()
		}
		
		waitForExpectationsWithTimeout(5, handler: nil)
	}
	
}
