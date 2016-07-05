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
		
		service.authenticate("user", password: "pass")
			.then { (response) -> Void in
				
				XCTAssertEqual(response.accessToken, "abc123-mock")
				expection.fulfill()
			}.error { (error) in
				print(error)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
		
	}
	
	func testReuseToken() {
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass")
			.then {
				(_) -> Void in
				
				service.checkToken().then { (response) -> Void in
					
					XCTAssertTrue(response.boolValue)
					expection.fulfill()
					
					}.error { (error) in
						XCTFail("Token is not valid: \((error as NSError).description)")
				}
				
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
		
	}
	
	func testGetVehicles() {
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass")
			.then {
				(_) -> Void in
				service.getVehicles()
					.then {
						(response) -> Void in
						
						XCTAssertEqual(response[0].displayName, "mockCar")
						
						expection.fulfill()
						
					}.error{ (error) in
						print(error)
						XCTFail((error as NSError).description)
				}
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
		
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
		
		service.authenticate("user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.getVehicleStatus(vehicles[0])
			}.then { (response) -> Void in
				
				XCTAssertEqual(response.mobileAccess, false)
				XCTAssertEqual(response.chargeState?.chargingState, .Complete)
				XCTAssertEqual(response.chargeState?.batteryRange?.miles, 200.0)
				XCTAssertEqual(response.climateState?.insideTemperature?.celsius,18.0)
				XCTAssertEqual(response.driveState?.position?.course,10.0)
				XCTAssertEqual(response.guiSettings?.distanceUnits,"km/hr")
				XCTAssertEqual(response.vehicleState?.darkRims, true)
				
				expection.fulfill()
			}.error { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
		
	}
	
	func testCommandWakeUp() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("WakeUp", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .WakeUp).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .WakeUp)
			}.then { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test wakeup")
				
				expection.fulfill()
			}.error { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
	}
	
	func testCommandValetMode() {
		
		let options = ValetCommandOptions(valetActivated: true, pin: "1234")
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("SetValetMode", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .ValetMode(options: options)).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles) in
				service.sendCommandToVehicle(vehicles[0], command: .ValetMode(options: options))
			}.then { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test valet")
				
				expection.fulfill()
			}.error { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
	}
	
	func testCommandResetValetPin() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("ResetValetPin", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .ResetValetPin).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .ResetValetPin)
			}.then { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test resetValet")
				
				expection.fulfill()
			}.error { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
	}
	
	func testCommandOpenChargePort() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("OpenChargeDoor", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .OpenChargeDoor).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .OpenChargeDoor)
			}.then { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test open charge door")
				
				expection.fulfill()
			}.error { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
	}
	
	func testCommandChargeStandard() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("ChargeLimitStandard", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .ChargeLimitStandard).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .ChargeLimitStandard)
			}.then { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test charge standard")
				
				expection.fulfill()
			}.error { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
	}
	
	func testCommandChargeMaxRate() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("ChargeLimitMaxRange", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .ChargeLimitMaxRange).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .ChargeLimitMaxRange)
			}.then { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test charge max range")
				
				expection.fulfill()
			}.error { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
	}
	
	func testCommandChargePercentage() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("ChargeLimitPercentage", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri("/api/1/vehicles/1234567890/command/set_charge_limit"), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .ChargeLimitPercentage(limit: 10))
			}.then { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test charge percentage")
				
				expection.fulfill()
			}.error { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
	}
	
	func testCommandStartCharging() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("StartCharging", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .StartCharging).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .StartCharging)
			}.then { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test start charging")
				
				expection.fulfill()
			}.error { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
	}
	
	func testCommandStopCharging() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("StopCharging", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .StopCharging).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .StopCharging)
			}.then { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test stop charging")
				
				expection.fulfill()
			}.error { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
	}
	
	func testCommandFlashLights() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("FlashLights", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .FlashLights).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .FlashLights)
			}.then { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test FlashLights")
				
				expection.fulfill()
			}.error { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
	}
	
	func testCommandHonkHorn() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("HonkHorn", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .HonkHorn).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .HonkHorn)
			}.then { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test HonkHorn")
				
				expection.fulfill()
			}.error { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
	}
	
	func testCommandUnlockDoors() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("UnlockDoors", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .UnlockDoors).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .UnlockDoors)
			}.then { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test UnlockDoors")
				
				expection.fulfill()
			}.error { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
	}
	
	func testCommandLockDoors() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("LockDoors", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .LockDoors).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .LockDoors)
			}.then { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test LockDoors")
				
				expection.fulfill()
			}.error { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
	}
	
	func testCommandSetTemperature() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("SetTemperature", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri("/api/1/vehicles/1234567890/command/set_temps"), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .SetTemperature(driverTemperature: 22.0, passangerTemperature: 23.0))
			}.then { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test SetTemperature")
				
				expection.fulfill()
			}.error { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
	}
	
	func testCommandStartAutoConditioning() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("StartAutoConditioning", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .StartAutoConditioning).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .StartAutoConditioning)
			}.then { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test StartAutoConditioning")
				
				expection.fulfill()
			}.error { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
	}
	
	func testCommandStopAutoConditioning() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("StopAutoConditioning", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .StopAutoConditioning).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .StopAutoConditioning)
			}.then { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test StopAutoConditioning")
				
				expection.fulfill()
			}.error { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
	}
	
	func testCommandSetSunRoof() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("SetSunRoof", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri("/api/1/vehicles/1234567890/command/sun_roof_control"), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .SetSunRoof(state: .Open, percentage: 20.0))
			}.then { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test SetSunRoof")
				
				expection.fulfill()
			}.error { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
	}
	
	func testCommandStartVehicle() {
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("StartVehicle", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri("/api/1/vehicles/1234567890/command/remote_start_drive"), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .StartVehicle(password: "pass"))
			}.then { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test StartVehicle")
				
				expection.fulfill()
			}.error { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
	}
	
	func testCommandOpenTrunk() {
		
		let options = OpenTrunkOptions.Rear
		
		let path = NSBundle(forClass: self.dynamicType).pathForResource("OpenTrunk", ofType: "json")!
		let data = NSData(contentsOfFile: path)!
		stub(uri(Endpoint.Command(vehicleID: 1234567890, command: .OpenTrunk(options: options)).path), builder: jsonData(data))
		
		let expection = expectationWithDescription("All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate("user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles) in
				service.sendCommandToVehicle(vehicles[0], command: .OpenTrunk(options: options))
			}.then { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test OpenTrunk")
				
				expection.fulfill()
			}.error { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectationsWithTimeout(2, handler: nil)
	}
}
