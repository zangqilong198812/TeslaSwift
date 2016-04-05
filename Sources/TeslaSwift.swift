//
//  TeslaSwift.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 04/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper
import BrightFutures
import Alamofire

enum Endpoint {
	
	case Authentication
	case Vehicles
	case MobileAccess(vehicleID: Int)
	case ChargeState(vehicleID: Int)
	case ClimateState(vehicleID: Int)
	case DriveState(vehicleID: Int)
	case GuiSettings(vehicleID: Int)
	case VehicleState(vehicleID: Int)
	case Command(vehicleID: Int, command:VehicleCommand)
}

extension Endpoint {

	var path:String {
		switch self {
		case .Authentication:
			return "/oauth/token"
		case .Vehicles:
			return "/api/1/vehicles"
		case .MobileAccess(let vehicleID):
			return "/api/1/vehicles/\(vehicleID)/mobile_enabled"
		case .ChargeState(let vehicleID):
			return "/api/1/vehicles/\(vehicleID)/data_request/charge_state"
		case .ClimateState(let vehicleID):
			return "/api/1/vehicles/\(vehicleID)/data_request/climate_state"
		case .DriveState(let vehicleID):
			return "/api/1/vehicles/\(vehicleID)/data_request/drive_state"
		case .GuiSettings(let vehicleID):
			return "/api/1/vehicles/\(vehicleID)/data_request/gui_settings"
		case .VehicleState(let vehicleID):
			return "/api/1/vehicles/\(vehicleID)/data_request/vehicle_state"
		case let .Command(vehicleID, command):
			return "/api/1/vehicles/\(vehicleID)/\(command)"
		}
	}
	
	var method: Alamofire.Method {
		switch self {
		case .Authentication, .Command:
			return .POST
		case .Vehicles,MobileAccess,ChargeState,ClimateState,DriveState,.GuiSettings,.VehicleState:
			return .GET
		}
	}
	
	func baseURL(useMockServer:Bool) -> String {
		if useMockServer {
			return "https://private-623898-modelsapi.apiary-mock.com"
		} else {
			return "https://owner-api.teslamotors.com"
		}
	}
}

public enum TeslaError:ErrorType {
	case NetworkError(error:NSError)
	case AuthenticationRequired
}

public enum VehicleCommand:String {
	case WakeUp = "wake_up"
}

public class TeslaSwift {
	
	public static let defaultInstance = TeslaSwift()
	public var useMockServer = true
	
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
	
	- returns: A Future with the AuthToken.
	*/

	public func authenticate(email:String, password:String) -> Future<AuthToken,TeslaError> {
		
		self.email = email
		self.password = password

		let body = AuthTokenRequest()
		body.email = email
		body.password = password
		body.grantType = "password"
		body.clientSecret = "c75f14bbadc8bee3a7594412c31416f8300256d7668ea7e6e7f06727bfb9d220"
		body.clientID = "e4a9949fcfa04068f59abb5a658f2bac0a3428e4652315490b659d5ab3f35a9e"
		
		return request(.Authentication, body: body)
			.andThen { (result) -> Void in
			self.token = result.value
		}
		
	}
	
	/**
	Fetchs the list of your vehicles including not yet delivered ones
	
	- returns: A Future with an array of Vehicles.
	*/
	public func getVehicles() -> Future<[Vehicle],TeslaError> {
		
		return checkAuthentication().flatMap { (token) -> Future<[Vehicle], TeslaError> in
			self.request(.Vehicles, body: nil, keyPath: "response")
		}
		
	}
	
	/**
	Fetchs the vehicle status
	
	- returns: A Future with VehicleDetails object containing all the possible status information.
	*/
	public func getVehicleStatus(vehicle:Vehicle) -> Future<VehicleDetails,TeslaError> {
		
		return checkAuthentication().flatMap {
			(token) -> Future<(((((AnyObject,ChargeState),ClimateState),DriveState),GuiSettings),VehicleState), TeslaError> in
			
			let vehicleID = vehicle.vehicleID!
			
			return self.request(.MobileAccess(vehicleID: vehicleID),body: nil)
				.zip(self.request(.ChargeState(vehicleID: vehicleID), body: nil, keyPath: "response"))
				.zip(self.request(.ClimateState(vehicleID: vehicleID), body: nil, keyPath: "response"))
				.zip(self.request(.DriveState(vehicleID: vehicleID), body: nil, keyPath: "response"))
				.zip(self.request(.GuiSettings(vehicleID: vehicleID), body: nil, keyPath: "response"))
				.zip(self.request(.VehicleState(vehicleID: vehicleID), body: nil, keyPath: "response"))
			
			}.flatMap {
				(result:((((mobileAccess:AnyObject, chargeState:ChargeState), climateState:ClimateState), driveState:DriveState), guiSettings:GuiSettings), vehicleState:VehicleState) -> Future<VehicleDetails, TeslaError> in
			
		
				let vehicleDetails = VehicleDetails()
				vehicleDetails.mobileAccess = (result.0.0.0.mobileAccess as! [String:Bool])["response"]
				vehicleDetails.chargeState = result.0.0.0.chargeState
				vehicleDetails.climateState = result.0.0.climateState
				vehicleDetails.driveState = result.0.driveState
				vehicleDetails.guiSettings = result.guiSettings
				vehicleDetails.vehicleState = vehicleState
				return Future<VehicleDetails,TeslaError>(value: vehicleDetails)
				
		}
		
	}
	
	public func sendCommandToVehicle(vehicle:Vehicle, command:VehicleCommand) -> Future<CommandResponse,TeslaError> {
	
		return checkAuthentication().flatMap { (token) -> Future<CommandResponse, TeslaError> in
			self.request(.Command(vehicleID: vehicle.vehicleID!, command: command), body: nil, keyPath: "response")
		}
		
	}
}

extension TeslaSwift {
	
	func checkToken() -> Future<Bool,TeslaError> {
		
		if let token = self.token {
			return Future<Bool,TeslaError>(value: token.isValid)
		} else {
			return Future<Bool,TeslaError>(value:false)
		}
	}
	
	func checkAuthentication() -> Future<AuthToken,TeslaError> {
		
		return checkToken().flatMap { (value) -> Future<AuthToken, TeslaError> in
			
			if (value) {
				return Future<AuthToken, TeslaError>(value: self.token!)
			} else {
				if let email = self.email, password = self.password {
					return self.authenticate(email, password: password)
				} else {
					return Future<AuthToken, TeslaError>(error: .AuthenticationRequired)
				}
				
			}
		}
	}
	
	func request<T:Mappable>(endpoint:Endpoint, body:Mappable?, keyPath:String? = nil) -> Future<T,TeslaError> {
		
		return prepareRequest(endpoint, body: body).responseObjectFuture(keyPath)
	}
	func request<T:Mappable>(endpoint:Endpoint, body:Mappable?, keyPath:String? = nil) -> Future<[T],TeslaError> {
		
		return prepareRequest(endpoint, body: body).responseObjectFuture(keyPath)
	}
	func request(endpoint:Endpoint, body:Mappable?) -> Future<AnyObject,TeslaError> {
		
		return prepareRequest(endpoint, body: body).responseObjectFuture()
	}
	
	func prepareRequest(endpoint:Endpoint, body:Mappable?) -> Request {
		
		let request = NSMutableURLRequest(URL: NSURL(string: endpoint.baseURL(useMockServer).stringByAppendingString(endpoint.path))!)
		request.HTTPMethod = endpoint.method.rawValue
		
		if let token = self.token?.accessToken {
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}
		
		if let body = body {
			let jsonObject = body.toJSON()
			request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(jsonObject, options: [])
			request.setValue("application/json", forHTTPHeaderField: "content-type")
		}
		let alamonfireRequest = Alamofire.request(request)
		
		print("Request: \(alamonfireRequest)")
		if let body = body {
			print("Request Body: \(body.toJSONString(true)!)")
		}
		
		return alamonfireRequest
	}
	
}
