//
//  TeslaSwift.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 04/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper
import PromiseKit

public enum RoofState: String {
	case Open		= "open"
	case Close		= "close"
	case Comfort	= "comfort"
	case Vent		= "vent"
	case Move		= "move"
}

public enum VehicleCommand {
	case wakeUp
	case valetMode(options:ValetCommandOptions)
	case resetValetPin
	case openChargeDoor
	case chargeLimitStandard
	case chargeLimitMaxRange
	case chargeLimitPercentage(limit:Int)
	case startCharging
	case stopCharging
	case flashLights
	case honkHorn
	case unlockDoors
	case lockDoors
	case setTemperature(driverTemperature:Double, passangerTemperature:Double)
	case startAutoConditioning
	case stopAutoConditioning
	case setSunRoof(state:RoofState, percentage:Double)
	case startVehicle(password:String)
	case openTrunk(options:OpenTrunkOptions)
	
	func path() -> String {
		switch self {
		case .wakeUp:
			return "wake_up"
		case .valetMode:
			return "command/set_valet_mode"
		case .resetValetPin:
			return "command/reset_valet_pin"
		case .openChargeDoor:
			return "command/charge_port_door_open"
		case .chargeLimitStandard:
			return "command/charge_standard"
		case .chargeLimitMaxRange:
			return "command/charge_max_range"
		case let .chargeLimitPercentage(limit):
			return  "command/set_charge_limit?percent=\(limit)"
		case .startCharging:
			return  "command/charge_start"
		case .stopCharging:
			return "command/charge_stop"
		case .flashLights:
			return "command/flash_lights"
		case .honkHorn:
			return "command/honk_horn"
		case .unlockDoors:
			return "command/door_unlock"
		case .lockDoors:
			return "command/door_lock"
		case let .setTemperature(driverTemperature, passangerTemperature):
			return "command/set_temps?driver_temp=\(driverTemperature)&passenger_temp=\(passangerTemperature)"
		case .startAutoConditioning:
			return "command/auto_conditioning_start"
		case .stopAutoConditioning:
			return "command/auto_conditioning_stop"
		case let .setSunRoof(state, percentage):
			return "command/sun_roof_control?state=\(state.rawValue)&percent=\(percentage)"
		case let .startVehicle(password):
			return "command/remote_start_drive?password=\(password)"
		case .openTrunk:
			return "command/trunk_open"
		}
	}
}

public enum TeslaError: Error {
	case networkError(error:NSError)
	case authenticationRequired
	case authenticationFailed
	case invalidOptionsForCommand
	case failedToParseData
}



open class TeslaSwift {
	
	open static let defaultInstance = TeslaSwift()
	open var useMockServer = false
	open var debuggingEnabled = false
	
	var token: AuthToken?
	
	fileprivate var email: String?
	fileprivate var password: String?
}

extension TeslaSwift {
	
	
	public var isAuthenticated: Bool {
		return token != nil
	}
	
	/**
	Performs the authentition with the Tesla API
	
	You only need to call this once. The token will be stored and your credentials.
	If the token expires your credentials will be reused.
	
	- parameter email:      The email address.
	- parameter password:   The password.
	
	- returns: A Promise with the AuthToken.
	*/

	public func authenticate(_ email: String, password: String) -> Promise<AuthToken> {
		
		self.email = email
		self.password = password

		let body = AuthTokenRequest()
		body.email = email
		body.password = password
		body.grantType = "password"
		body.clientSecret = "c75f14bbadc8bee3a7594412c31416f8300256d7668ea7e6e7f06727bfb9d220"
		body.clientID = "e4a9949fcfa04068f59abb5a658f2bac0a3428e4652315490b659d5ab3f35a9e"
		
		return request(.authentication, body: body)
			.then(on: .global()) { (result: AuthToken) -> AuthToken in
				self.token = result
				return result
		}.recover { (error) -> AuthToken in

			if (error as NSError).code == 401 {
				throw TeslaError.authenticationFailed
			} else {
				throw error
			}
		}
		
	}
	
	/**
	Fetchs the list of your vehicles including not yet delivered ones
	
	- returns: A Promise with an array of Vehicles.
	*/
	public func getVehicles() -> Promise<[Vehicle]> {
		
		return checkAuthentication().then(on: .global()) { (token) -> Promise<[Vehicle]> in
			self.request(.vehicles, body: nil)
				.then(on: .global()) { (data: GenericArrayResponse<Vehicle>) -> [Vehicle] in
					data.response
			}
		}
		
	}
	
	/**
	Fetchs the vehicle status
	
	- returns: A Promise with VehicleDetails object containing all the possible status information.
	*/
	public func getVehicleStatus(_ vehicle: Vehicle) -> Promise<VehicleDetails> {
		
		return checkAuthentication().then(on: .global()) {
			(token) -> Promise<(Bool, ChargeState, ClimateState, DriveState, GuiSettings, VehicleState)> in
			
			let vehicleID = vehicle.vehicleID!
			
			let p1 = self.request(.mobileAccess(vehicleID: vehicleID))
				.then(on: .global()) { (data: GenericBoolResponse) -> Bool in
					data.response
				}
			let p2 = self.request(.chargeState(vehicleID: vehicleID))
				.then(on: .global()) { (data: GenericResponse<ChargeState>) -> ChargeState in
					data.response
				}
			let p3 = self.request(.climateState(vehicleID: vehicleID))
				.then(on: .global()) { (data: GenericResponse<ClimateState>) -> ClimateState in
					data.response
				}
			let p4 = self.request(.driveState(vehicleID: vehicleID))
				.then(on: .global()) { (data: GenericResponse<DriveState>) -> DriveState in
					data.response
				}
			let p5 = self.request(.guiSettings(vehicleID: vehicleID))
				.then(on: .global()) { (data: GenericResponse<GuiSettings>) -> GuiSettings in
					data.response
				}
			let p6 = self.request(.vehicleState(vehicleID: vehicleID))
				.then(on: .global()) { (data: GenericResponse<VehicleState>) -> VehicleState in
					data.response
				}
			
			return when(fulfilled: p1.asVoid(), p2.asVoid(), p3.asVoid(), p4.asVoid(), p5.asVoid(), p6.asVoid()).then(on: .global()) {
				return (p1.value!, p2.value!, p3.value!, p4.value!, p5.value!, p6.value!)
			}
			
			}.then(on: .global()) {
				(mobileAccess: Bool, chargeState: ChargeState, climateState: ClimateState, driveState: DriveState, guiSettings: GuiSettings, vehicleState: VehicleState) -> Promise<VehicleDetails> in
				
				let vehicleDetails = VehicleDetails()
				vehicleDetails.mobileAccess = mobileAccess
				vehicleDetails.chargeState = chargeState
				vehicleDetails.climateState = climateState
				vehicleDetails.driveState = driveState
				vehicleDetails.guiSettings = guiSettings
				vehicleDetails.vehicleState = vehicleState
				return Promise<VehicleDetails>(value: vehicleDetails)
				
		}
		
	}
	
	
	/**
	Sends a command to the vehicle
	
	- parameter vehicle: the vehicle that will receive the command
	- parameter command: the command to send to the vehicle
	- returns: A Promise with the CommandResponse object containing the results of the command.
	*/
	public func sendCommandToVehicle(_ vehicle: Vehicle, command: VehicleCommand) -> Promise<CommandResponse> {
		
		var body: Mappable?
		
		switch command {
		case let .valetMode(options):
			body = options
		case let .openTrunk(options):
			body = options
		default: break
		}
		
		return checkAuthentication()
			.then(on: .global()) { (token) -> Promise<CommandResponse> in
			self.request(.command(vehicleID: vehicle.vehicleID!, command: command), body: body)
		}
		
	}
}

extension TeslaSwift {
	
	func checkToken() -> Promise<Bool> {
		
		if let token = self.token {
			return Promise<Bool>(value: token.isValid)
		} else {
			return Promise<Bool>(value: false)
		}
	}
	
	
	func checkAuthentication() -> Promise<AuthToken> {
		
		return checkToken().then { (value) -> Promise<AuthToken> in
			
			if value {
				return Promise<AuthToken>(value: self.token!)
			} else {
				if let email = self.email, let password = self.password {
					return self.authenticate(email, password: password)
				} else {
					return Promise<AuthToken>(error: TeslaError.authenticationRequired)
				}
				
			}
		}
	}
	
	func request<T: Mappable>(_ endpoint: Endpoint, body: Mappable? = nil) -> Promise<T> {
		
		let (promise, fulfill, reject) = Promise<T>.pending()
		
		let request = prepareRequest(endpoint, body: body) as URLRequest
		let debugEnabled = debuggingEnabled
		let task = URLSession.shared.dataTask(with: request, completionHandler:  {
			(data, response, error) in
			
			logDebug("Respose: \(response)", debuggingEnabled: debugEnabled)
			
			guard error == nil else { reject(error!); return }
			guard let httpResponse = response as? HTTPURLResponse else { reject(TeslaError.failedToParseData); return }
			
			if case 200..<300 = httpResponse.statusCode {
				
				if let data = data {
					do {
						let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
						logDebug("Respose Body: \(object)", debuggingEnabled: debugEnabled)
						if let mapped = Mapper<T>().map(object) {
							fulfill(mapped)
						} else {
							reject(TeslaError.failedToParseData)
						}
					} catch {
						reject(TeslaError.failedToParseData)
					}
				} else {
					reject(TeslaError.failedToParseData)
				}
				
			} else {
				reject(NSError(domain: "TeslaError", code: httpResponse.statusCode, userInfo: nil))
			}
			
			
		}) 
		task.resume()
		
		return promise
	}
	/*func request<T:Mappable>(endpoint:Endpoint, body:Mappable?) -> Future<[T],TeslaError> {
		
		return prepareRequest(endpoint, body: body).responseObjectFuture(keyPath, logging: debuggingEnabled)
	}*/
	
	func prepareRequest(_ endpoint: Endpoint, body: Mappable?) -> NSMutableURLRequest {
		
		let request = NSMutableURLRequest(url: URL(string: endpoint.baseURL(useMockServer) + endpoint.path)!)
		request.httpMethod = endpoint.method
		
		if let token = self.token?.accessToken {
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}
		
		if let body = body {
			let jsonObject = body.toJSON()
			request.httpBody = try? JSONSerialization.data(withJSONObject: jsonObject, options: [])
			request.setValue("application/json", forHTTPHeaderField: "content-type")
		}
		
		logDebug("Request: \(request)", debuggingEnabled: debuggingEnabled)
		if let body = body {
			logDebug("Request Body: \(body.toJSONString(true)!)", debuggingEnabled: debuggingEnabled)
		}
		
		return request
	}
	
}

func logDebug(_ format: String, debuggingEnabled: Bool) {
	if debuggingEnabled {
		NSLog(format)
	}
}
