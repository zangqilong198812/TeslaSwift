//
//  TeslaSwiftTests.swift
//  TeslaSwiftTests
//
//  Created by Joao Nunes on 04/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import XCTest
@testable import TeslaSwift
import OHHTTPStubs

class TeslaSwiftTests: XCTestCase {
	
	let headers = ["Content-Type" as NSObject :"application/json" as AnyObject]
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
		
		let stubPath = OHPathForFile("Authentication.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.authentication.path)) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}
		
		let path2 = OHPathForFile("Vehicles.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.vehicles.path)) {
			_ in
			return fixture(filePath: path2!, headers: self.headers)
		}
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
		
	}
	
	// MARK: - Authentication -
	
	func testAuthenticate() {
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass")
			.done { (response) -> Void in
				
				XCTAssertEqual(response.accessToken, "abc123-mock")
				expection.fulfill()
			}.catch { (error) in
				print(error)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
		
	}
	
	func testAuthenticationFailed() {
		
		let stubPath = OHPathForFile("AuthenticationFailed.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.authentication.path)) {
			_ in
			return fixture(filePath: stubPath!, status: 401, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass")
			.done { (response) -> Void in
				
				XCTFail("Authentication must fail")
				expection.fulfill()
			}.catch { (error) in
				if case TeslaError.authenticationFailed = error {
					
				} else {
					XCTFail("Authentication must fail")
				}
				expection.fulfill()
		}
		
		waitForExpectations(timeout: 2, handler: nil)
		
	}
	
	func testReuseFailedToken() {
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		_ = service.authenticate(email: "user", password: "pass")
			.done {
				(_) in
				
				service.checkToken().done { (response) in
					
					XCTAssertFalse(response)
					expection.fulfill()
					
					}.catch { (error) in
						XCTFail("Token is not valid: \((error as NSError).description)")
				}
				
		}
		
		waitForExpectations(timeout: 2, handler: nil)
		
	}
	
	func testReuseToken() {
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		_ = service.authenticate(email: "user", password: "pass")
			.done {
				(_) -> Void in
				
				service.token?.createdAt = Date()
				
				service.checkToken().done { (response) -> Void in
					
					XCTAssertTrue(response)
					expection.fulfill()
					
					}.catch { (error) in
						XCTFail("Token is not valid: \((error as NSError).description)")
				}
				
		}
		
		waitForExpectations(timeout: 2, handler: nil)
		
	}
	
	// MARK: - Vehicles -
	
	func testGetVehicles() {
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		_ = service.authenticate(email: "user", password: "pass")
			.done {
				(_) in
				service.getVehicles()
					.done {
						(response) in
						
						XCTAssertEqual(response[0].displayName, "mockCar")
						
						expection.fulfill()
						
					}.catch{ (error) in
						print(error)
						XCTFail((error as NSError).description)
				}
		}
		
		waitForExpectations(timeout: 2, handler: nil)
		
	}
	
	// MARK: - Vehicle states -
	
	func testGetVehicleMobileState() {
		
		let stubPath = OHPathForFile("MobileAccess.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.mobileAccess(vehicleID: "321").path)) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.getVehicleMobileAccessState(vehicles[0])
			}.done { (response) -> Void in
				
				XCTAssertEqual(response, false)
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
		
	}
	
	func testGetAllStates() {
		
		let stubPath2 = OHPathForFile("AllStates.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.allStates(vehicleID: "321").path)) {
			_ in
			return fixture(filePath: stubPath2!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.getAllData(vehicles[0])
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.userId, 1234)
				XCTAssertEqual(response.chargeState?.chargingState, .Disconnected)
				XCTAssertEqual(response.vehicleConfig?.trimBadging, "85")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
				expection.fulfill()
		}
		
		waitForExpectations(timeout: 2, handler: nil)
		
	}
	
	
	func testGetVehicleChargeState() {
		
		let stubPath2 = OHPathForFile("ChargeState.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.chargeState(vehicleID: "321").path)) {
			_ in
			return fixture(filePath: stubPath2!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.getVehicleChargeState(vehicles[0])
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.chargingState, .Complete)
				XCTAssertEqual(response.ratedBatteryRange?.miles, 200.0)
				XCTAssertEqual(response.batteryHeaterOn, true)
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
		
	}
	
	func testGetVehicleClimateSettings() {
		
		let stubPath3 = OHPathForFile("ClimateSettings.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.climateState(vehicleID: "321").path)) {
			_ in
			return fixture(filePath: stubPath3!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.getVehicleClimateState(vehicles[0])
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.insideTemperature?.celsius,18.0)
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
		
	}

	func testGetVehicleDriveState() {
		
		let stubPath4 = OHPathForFile("DriveState.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.driveState(vehicleID: "321").path)) {
			_ in
			return fixture(filePath: stubPath4!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.getVehicleDriveState(vehicles[0])
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.position?.course,10.0)
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
		
	}

	func testGetVehicleGuiSettings() {
		
		let stubPath5 = OHPathForFile("GuiSettings.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.guiSettings(vehicleID: "321").path)) {
			_ in
			return fixture(filePath: stubPath5!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.getVehicleGuiSettings(vehicles[0])
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.distanceUnits,"km/hr")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
		
	}

	func testGetVehicleState() {
		
		let stubPath6 = OHPathForFile("VehicleState.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.vehicleState(vehicleID: "321").path)) {
			_ in
			return fixture(filePath: stubPath6!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.getVehicleState(vehicles[0])
			}.done { (response) -> Void in
			
				XCTAssertEqual(response.locked, true)
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
				expection.fulfill()
		}
		
		waitForExpectations(timeout: 2, handler: nil)
		
	}


	// MARK:  - Commands -
	
	func testCommandWakeUp() {
		
		let stubPath = OHPathForFile("WakeUp.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.command(vehicleID: "321", command: .wakeUp).path)) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .wakeUp)
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test wakeup")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
	}
	
	func testCommandValetMode() {

		let stubPath = OHPathForFile("SetValetMode.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.command(vehicleID: "321", command: .valetMode(valetActivated: true, pin: "1234")).path)) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}

		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles) in
				service.sendCommandToVehicle(vehicles[0], command: .valetMode(valetActivated: true, pin: "1234"))
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test valet")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
	}
	
	func testCommandResetValetPin() {
		
		let stubPath = OHPathForFile("ResetValetPin.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.command(vehicleID: "321", command: .resetValetPin).path)) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .resetValetPin)
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test resetValet")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
	}
	
	func testCommandOpenChargePort() {
		
		let stubPath = OHPathForFile("OpenChargeDoor.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.command(vehicleID: "321", command: .openChargeDoor).path)) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .openChargeDoor)
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test open charge door")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
	}
	
	func testCommandChargeStandard() {
		
		let stubPath = OHPathForFile("ChargeLimitStandard.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.command(vehicleID: "321", command: .chargeLimitStandard).path)) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .chargeLimitStandard)
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test charge standard")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
	}
	
	func testCommandChargeMaxRate() {
		
		let stubPath = OHPathForFile("ChargeLimitMaxRange.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.command(vehicleID: "321", command: .chargeLimitMaxRange).path)) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}

		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .chargeLimitMaxRange)
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test charge max range")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
	}
	
	func testCommandChargePercentage() {
		
		let stubPath = OHPathForFile("ChargeLimitPercentage.json", type(of: self))
		_ = stub(condition: isPath("/api/1/vehicles/321/command/set_charge_limit")) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .chargeLimitPercentage(limit: 10))
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test charge percentage")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
	}
	
	func testCommandStartCharging() {
		
		let stubPath = OHPathForFile("StartCharging.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.command(vehicleID: "321", command: .startCharging).path)) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .startCharging)
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test start charging")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
	}
	
	func testCommandStopCharging() {
		
		let stubPath = OHPathForFile("StopCharging.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.command(vehicleID: "321", command: .stopCharging).path)) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .stopCharging)
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test stop charging")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
	}
	
	func testCommandFlashLights() {
		
		let stubPath = OHPathForFile("FlashLights.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.command(vehicleID: "321", command: .flashLights).path)) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .flashLights)
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test FlashLights")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
	}
	
	func testCommandHonkHorn() {
		
		let stubPath = OHPathForFile("HonkHorn.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.command(vehicleID: "321", command: .honkHorn).path)) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .honkHorn)
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test HonkHorn")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
	}
	
	func testCommandUnlockDoors() {
		
		let stubPath = OHPathForFile("UnlockDoors.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.command(vehicleID: "321", command: .unlockDoors).path)) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .unlockDoors)
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test UnlockDoors")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
	}
	
	func testCommandLockDoors() {
		
		let stubPath = OHPathForFile("LockDoors.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.command(vehicleID: "321", command: .lockDoors).path)) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .lockDoors)
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test LockDoors")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
	}
	
	func testCommandSetTemperature() {
		
		let stubPath = OHPathForFile("SetTemperature.json", type(of: self))
		_ = stub(condition: isPath("/api/1/vehicles/321/command/set_temps")) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .setTemperature(driverTemperature: 22.0, passengerTemperature: 23.0))
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test SetTemperature")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
	}
	
	func testCommandStartAutoConditioning() {
		
		let stubPath = OHPathForFile("StartAutoConditioning.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.command(vehicleID: "321", command: .startAutoConditioning).path)) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .startAutoConditioning)
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test StartAutoConditioning")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
	}
	
	func testCommandStopAutoConditioning() {
		
		let stubPath = OHPathForFile("StopAutoConditioning.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.command(vehicleID: "321", command: .stopAutoConditioning).path)) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .stopAutoConditioning)
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test StopAutoConditioning")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
	}
	
	func testCommandSetSunRoof() {
		
		let stubPath = OHPathForFile("SetSunRoof.json", type(of: self))
		_ = stub(condition: isPath("/api/1/vehicles/321/command/sun_roof_control")) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles: [Vehicle])  in
				service.sendCommandToVehicle(vehicles[0], command: .setSunRoof(state: .close, percentage: 20))
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test SetSunRoof")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
	}
	
	func testCommandStartVehicle() {
		
		let stubPath = OHPathForFile("StartVehicle.json", type(of: self))
		_ = stub(condition: isPath("/api/1/vehicles/321/command/remote_start_drive")) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles)  in
				service.sendCommandToVehicle(vehicles[0], command: .startVehicle(password: "pass"))
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test StartVehicle")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
	}
	
	func testCommandOpenTrunk() {
		
		let options = OpenTrunkOptions.rear
		
		let stubPath = OHPathForFile("OpenTrunk.json", type(of: self))
		_ = stub(condition: isPath(Endpoint.command(vehicleID: "321", command: .openTrunk(options: options)).path)) {
			_ in
			return fixture(filePath: stubPath!, headers: self.headers)
		}
		
		let expection = expectation(description: "All Done")
		
		let service = TeslaSwift()
		service.useMockServer = true
		
		service.authenticate(email: "user", password: "pass").then { (token) in
			service.getVehicles()
			}.then { (vehicles) in
				service.sendCommandToVehicle(vehicles[0], command: .openTrunk(options: options))
			}.done { (response) -> Void in
				
				XCTAssertEqual(response.result, false)
				XCTAssertEqual(response.reason, "Test OpenTrunk")
				
				expection.fulfill()
			}.catch { (error) in
				print(error)
				XCTFail((error as NSError).description)
		}
		
		waitForExpectations(timeout: 2, handler: nil)
	}
	
	//MARK: - Streaming -
	
    func testStreamVehicleInformation() {
		
		let stubPath = OHPathForFile("StreamingData.txt", type(of: self))
		_ = stub(condition: pathStartsWith("/stream/1234567890")) {
			_ in
			return fixture(filePath: stubPath!, headers: [:])
		}
		
        let service = TeslaSwift()
        service.useMockServer = true
        let expection = expectation(description: "All Done")
        
        service.authenticate(email: "user", password: "pass").then { (token) in
                service.getVehicles()
			}.done { (vehicles: [Vehicle]) in
				service.openStream(vehicle: vehicles[0], dataReceived: {
					(event: StreamEvent?, error: Error?) in
					if event != nil {
						XCTAssertEqual(event!.elevation,17)
						expection.fulfill()
					}
				})
            }.catch { (error) in
                XCTFail((error as NSError).description)
        }
		
		waitForExpectations(timeout: 2, handler: nil)

    }
	
	//MARK: - Parsing extra -
	
	func testParseEmpty() {
		
		XCTAssertNoThrow( { () -> VehicleExtended? in "{}".decodeJSON() }())
		
	}
}
