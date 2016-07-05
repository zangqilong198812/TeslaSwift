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

public enum RoofState:String {
	case Open		= "open"
	case Close		= "close"
	case Comfort	= "comfort"
	case Vent		= "vent"
	case Move		= "move"
}

public enum VehicleCommand {
	case WakeUp
	case ValetMode(options:ValetCommandOptions)
	case ResetValetPin
	case OpenChargeDoor
	case ChargeLimitStandard
	case ChargeLimitMaxRange
	case ChargeLimitPercentage(limit:Int)
	case StartCharging
	case StopCharging
	case FlashLights
	case HonkHorn
	case UnlockDoors
	case LockDoors
	case SetTemperature(driverTemperature:Double, passangerTemperature:Double)
	case StartAutoConditioning
	case StopAutoConditioning
	case SetSunRoof(state:RoofState, percentage:Double)
	case StartVehicle(password:String)
	case OpenTrunk(options:OpenTrunkOptions)
	
	func path() -> String {
		switch self {
		case .WakeUp:
			return "wake_up"
		case .ValetMode:
			return "command/set_valet_mode"
		case .ResetValetPin:
			return "command/reset_valet_pin"
		case .OpenChargeDoor:
			return "command/charge_port_door_open"
		case .ChargeLimitStandard:
			return "command/charge_standard"
		case .ChargeLimitMaxRange:
			return "command/charge_max_range"
		case let .ChargeLimitPercentage(limit):
			return  "command/set_charge_limit?percent=\(limit)"
		case .StartCharging:
			return  "command/charge_start"
		case .StopCharging:
			return "command/charge_stop"
		case .FlashLights:
			return "command/flash_lights"
		case .HonkHorn:
			return "command/honk_horn"
		case .UnlockDoors:
			return "command/door_unlock"
		case .LockDoors:
			return "command/door_lock"
		case let .SetTemperature(driverTemperature, passangerTemperature):
			return "command/set_temps?driver_temp=\(driverTemperature)&passenger_temp=\(passangerTemperature)"
		case .StartAutoConditioning:
			return "command/auto_conditioning_start"
		case .StopAutoConditioning:
			return "command/auto_conditioning_stop"
		case let .SetSunRoof(state, percentage):
			return "command/sun_roof_control?state=\(state.rawValue)&percent=\(percentage)"
		case let .StartVehicle(password):
			return "command/remote_start_drive?password=\(password)"
		case .OpenTrunk:
			return "command/trunk_open"
		}
	}
}

public enum TeslaError:ErrorType {
	case NetworkError(error:NSError)
	case AuthenticationRequired
	case AuthenticationFailed
	case InvalidOptionsForCommand
	case FailedToParseData
}



public class TeslaSwift {
	
	public static let defaultInstance = TeslaSwift()
	public var useMockServer = false
	public var debuggingEnabled = false
	
	var token:AuthToken?
	
	private var email:String?
	private var password:String?
}

extension TeslaSwift {
	
	
	public var isAuthenticated:Bool {
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

	public func authenticate(email:String, password:String) -> Promise<AuthToken> {
		
		self.email = email
		self.password = password

		let body = AuthTokenRequest()
		body.email = email
		body.password = password
		body.grantType = "password"
		body.clientSecret = "c75f14bbadc8bee3a7594412c31416f8300256d7668ea7e6e7f06727bfb9d220"
		body.clientID = "e4a9949fcfa04068f59abb5a658f2bac0a3428e4652315490b659d5ab3f35a9e"
		
		return request(.Authentication, body: body)
			.thenInBackground { (result:AuthToken) -> AuthToken in
				self.token = result
				return result
		}.recover { (error) -> AuthToken in

			if (error as NSError).code == 401 {
				throw TeslaError.AuthenticationFailed
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
		
		return checkAuthentication().thenInBackground { (token) -> Promise<[Vehicle]> in
			self.request(.Vehicles, body: nil)
				.thenInBackground { (data:GenericArrayResponse<Vehicle>) -> [Vehicle] in
					data.response
			}
		}
		
	}
	
	/**
	Fetchs the vehicle status
	
	- returns: A Promise with VehicleDetails object containing all the possible status information.
	*/
	public func getVehicleStatus(vehicle:Vehicle) -> Promise<VehicleDetails> {
		
		return checkAuthentication().thenInBackground {
			(token) -> Promise<(Bool,ChargeState,ClimateState,DriveState,GuiSettings,VehicleState)> in
			
			let vehicleID = vehicle.vehicleID!
			
			let p1 = self.request(.MobileAccess(vehicleID: vehicleID))
				.thenInBackground { (data:GenericBoolResponse) -> Bool in
					data.response
				}
			let p2 = self.request(.ChargeState(vehicleID: vehicleID))
				.thenInBackground { (data:GenericResponse<ChargeState>) -> ChargeState in
					data.response
				}
			let p3 = self.request(.ClimateState(vehicleID: vehicleID))
				.thenInBackground { (data:GenericResponse<ClimateState>) -> ClimateState in
					data.response
				}
			let p4 = self.request(.DriveState(vehicleID: vehicleID))
				.thenInBackground { (data:GenericResponse<DriveState>) -> DriveState in
					data.response
				}
			let p5 = self.request(.GuiSettings(vehicleID: vehicleID))
				.thenInBackground { (data:GenericResponse<GuiSettings>) -> GuiSettings in
					data.response
				}
			let p6 = self.request(.VehicleState(vehicleID: vehicleID))
				.thenInBackground { (data:GenericResponse<VehicleState>) -> VehicleState in
					data.response
				}
			
			return when(p1.asVoid(), p2.asVoid(), p3.asVoid(), p4.asVoid(), p5.asVoid(), p6.asVoid()).thenInBackground {
				return (p1.value!,p2.value!,p3.value!,p4.value!, p5.value!, p6.value!)
			}
			
			}.thenInBackground {
				(mobileAccess:Bool, chargeState:ChargeState, climateState:ClimateState, driveState:DriveState, guiSettings:GuiSettings, vehicleState:VehicleState) -> Promise<VehicleDetails> in
				
				let vehicleDetails = VehicleDetails()
				vehicleDetails.mobileAccess = mobileAccess
				vehicleDetails.chargeState = chargeState
				vehicleDetails.climateState = climateState
				vehicleDetails.driveState = driveState
				vehicleDetails.guiSettings = guiSettings
				vehicleDetails.vehicleState = vehicleState
				return Promise<VehicleDetails>(vehicleDetails)
				
		}
		
	}
	
	
	/**
	Sends a command to the vehicle
	
	- parameter vehicle: the vehicle that will receive the command
	- parameter command: the command to send to the vehicle
	- returns: A Promise with the CommandResponse object containing the results of the command.
	*/
	public func sendCommandToVehicle(vehicle:Vehicle, command:VehicleCommand) -> Promise<CommandResponse> {
		
		var body:Mappable?
		
		switch command {
		case let .ValetMode(options):
			body = options
		case let .OpenTrunk(options):
			body = options
		default: break
		}
		
		return checkAuthentication()
			.thenInBackground { (token) -> Promise<CommandResponse> in
			self.request(.Command(vehicleID: vehicle.vehicleID!, command: command), body: body)
		}
		
	}
}

extension TeslaSwift {
	
	func checkToken() -> Promise<Bool> {
		
		if let token = self.token {
			return Promise<Bool>(token.isValid)
		} else {
			return Promise<Bool>(false)
		}
	}
	
	
	func checkAuthentication() -> Promise<AuthToken> {
		
		return checkToken().then { (value) -> Promise<AuthToken> in
			
			if (value) {
				return Promise<AuthToken>(self.token!)
			} else {
				if let email = self.email, password = self.password {
					return self.authenticate(email, password: password)
				} else {
					return Promise<AuthToken>(error: TeslaError.AuthenticationRequired)
				}
				
			}
		}
	}
	
	func request<T:Mappable>(endpoint:Endpoint, body:Mappable? = nil) -> Promise<T> {
		
		let (promise,fulfill,reject) = Promise<T>.pendingPromise()
		
		let request:NSMutableURLRequest = prepareRequest(endpoint, body: body)
		let debugEnabled = debuggingEnabled
		let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
			(data, response, error) in
			
			logDebug("Respose: \(response)", debuggingEnabled: debugEnabled)
			
			guard error == nil else { reject(error!); return }
			guard let httpResponse = response as? NSHTTPURLResponse else { reject(TeslaError.FailedToParseData); return }
			
			if case 200..<300 = httpResponse.statusCode {
				
				if let data = data {
					do {
						let object = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
						logDebug("Respose Body: \(object)", debuggingEnabled: debugEnabled)
						if let mapped = Mapper<T>().map(object) {
							fulfill(mapped)
						}
					}
					catch {
						reject(TeslaError.FailedToParseData)
					}
				} else {
					reject(TeslaError.FailedToParseData)
				}
				
			} else {
				reject(NSError(domain: "TeslaError", code: httpResponse.statusCode, userInfo: nil))
			}
			
			
		}
		task.resume()
		
		return promise
	}
	/*func request<T:Mappable>(endpoint:Endpoint, body:Mappable?) -> Future<[T],TeslaError> {
		
		return prepareRequest(endpoint, body: body).responseObjectFuture(keyPath, logging: debuggingEnabled)
	}*/
	
	func prepareRequest(endpoint:Endpoint, body:Mappable?) -> NSMutableURLRequest {
		
		let request = NSMutableURLRequest(URL: NSURL(string: endpoint.baseURL(useMockServer).stringByAppendingString(endpoint.path))!)
		request.HTTPMethod = endpoint.method
		
		if let token = self.token?.accessToken {
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}
		
		if let body = body {
			let jsonObject = body.toJSON()
			request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(jsonObject, options: [])
			request.setValue("application/json", forHTTPHeaderField: "content-type")
		}
		
		logDebug("Request: \(request)", debuggingEnabled: debuggingEnabled)
		if let body = body {
			logDebug("Request Body: \(body.toJSONString(true)!)", debuggingEnabled: debuggingEnabled)
		}
		
		return request
	}
	
}

func logDebug(format: String, debuggingEnabled: Bool) {
	if debuggingEnabled {
		NSLog(format)
	}
}
