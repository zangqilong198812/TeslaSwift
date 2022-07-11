//
//  TeslaSwift.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 04/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import os.log

public enum TeslaError: Error, Equatable {
    case networkError(error: NSError)
    case authenticationRequired
    case authenticationFailed
    case tokenRevoked
    case noTokenToRefresh
    case tokenRefreshFailed
    case invalidOptionsForCommand
    case failedToParseData
    case failedToReloadVehicle
    case internalError
}

let ErrorInfo = "ErrorInfo"
private var nullBody = ""

open class TeslaSwift {
    open var debuggingEnabled = false

    open fileprivate(set) var token: AuthToken?

    open fileprivate(set) var email: String?
    fileprivate var password: String?

    public init() { }
}

extension TeslaSwift {

    public var isAuthenticated: Bool {
        return token != nil && (token?.isValid ?? false)
    }

    #if canImport(WebKit) && canImport(UIKit)
    /**
     Performs the authentication with the Tesla API for web logins

     For MFA users, this is the only way to authenticate.
     If the token expires, a token refresh will be done

     - returns: A ViewController that your app needs to present. This ViewController will ask the user for his/her Tesla credentials, MFA code if set and then dismiss on successful authentication.
     An async function that returns when the token as been retrieved
     */
    public func authenticateWeb() -> (TeslaWebLoginViewController?, () async throws -> AuthToken) {

        let codeRequest = AuthCodeRequest()
        let endpoint = Endpoint.oAuth2Authorization(auth: codeRequest)
        var urlComponents = URLComponents(string: endpoint.baseURL())
        urlComponents?.path = endpoint.path
        urlComponents?.queryItems = endpoint.queryParameters

        guard let safeUrlComponents = urlComponents else {
            func error() async throws -> AuthToken {
                throw TeslaError.authenticationFailed
            }
            return (nil, error)
        }

        let teslaWebLoginViewController = TeslaWebLoginViewController(url: safeUrlComponents.url!)

        func result() async throws -> AuthToken {
                let url = try await teslaWebLoginViewController.result()
                let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
                if let queryItems = urlComponents?.queryItems {
                    for queryItem in queryItems {
                        if queryItem.name == "code", let code = queryItem.value {
                            return try await self.getAuthenticationTokenForWeb(code: code)
                        }
                    }
                }
            throw TeslaError.authenticationFailed
        }
        return (teslaWebLoginViewController, result)
    }
    #endif

    private func getAuthenticationTokenForWeb(code: String) async throws -> AuthToken {

        let body = AuthTokenRequestWeb(code: code)

        do {
            let token: AuthToken = try await request(.oAuth2Token, body: body)
            self.token = token
            return token
        } catch let error {
            if case let TeslaError.networkError(error: internalError) = error {
                if internalError.code == 302 || internalError.code == 403 {
                    return try await self.request(.oAuth2TokenCN, body: body)
                } else if internalError.code == 401 {
                    throw TeslaError.authenticationFailed
                } else {
                    throw error
                }
            } else {
                throw error
            }
        }
    }

    /**
     Performs the token refresh with the Tesla API for Web logins

     - returns: The AuthToken.
     */
    public func refreshWebToken() async throws -> AuthToken {
        guard let token = self.token else { throw TeslaError.noTokenToRefresh }
        let body = AuthTokenRequestWeb(grantType: .refreshToken, refreshToken: token.refreshToken)

        do {
            let authToken: AuthToken = try await request(.oAuth2Token, body: body)
            self.token = authToken
            return authToken
        } catch let error {
            if case let TeslaError.networkError(error: internalError) = error {
                if internalError.code == 302 || internalError.code == 403 {
                    //Handle redirection for tesla.cn
                    return try await self.request(.oAuth2TokenCN, body: body)
                } else if internalError.code == 401 {
                    throw TeslaError.tokenRefreshFailed
                } else {
                    throw error
                }
            } else {
                throw error
            }
        }
    }

	/**
	Use this method to reuse a previous authentication token
	
	This method is useful if your app wants to ask the user for credentials once and reuse the token skipping authentication
	If the token is invalid a new authentication will be required
	
	- parameter token:      The previous token
	- parameter email:      Email is required for streaming
	*/
	public func reuse(token: AuthToken, email: String? = nil) {
		self.token = token
		self.email = email
	}

    /**
     Revokes the stored token. Not working

     - returns: The token revoke state.
     */
    public func revokeWeb() async throws -> Bool {
        guard let accessToken = self.token?.accessToken else {
            cleanToken()
            return false
        }

        _ = try await checkAuthentication()
        self.cleanToken()

        let response: BoolResponse = try await request(.oAuth2revoke(token: accessToken), body: nullBody)
        return response.response
    }

	/**
	Removes all the information related to the previous authentication
	
	*/
	public func logout() {
		email = nil
		password = nil
		cleanToken()
        #if canImport(WebKit) && canImport(UIKit)
        TeslaWebLoginViewController.removeCookies()
        #endif
	}
	/**
	Fetchs the list of your vehicles including not yet delivered ones
	
	- returns: An array of Vehicles.
	*/
    public func getVehicles(completion: @escaping (Result<[Vehicle], Error>) -> ()) -> Void {
        
        checkAuthentication { (result: Result<AuthToken, Error>) in
            
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                
                self.request(.vehicles, body: nullBody) { (result: Result<ArrayResponse<Vehicle>, Error>) in
                    switch result {
                    case .failure(let error):
                        completion(Result.failure(error))
                    case .success(let data):
                        completion(Result.success(data.response))
                    }
                }
            }
        }
		
	}
    
    /**
    Fetchs the list of your products
     
    - returns: A completion handler with an array of Products.
    */
    public func getProducts(completion: @escaping (Result<[Product], Error>) -> ()) -> Void {
        
        checkAuthentication { (result: Result<AuthToken, Error>) in
            
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                
                self.request(.products, body: nullBody) { (result: Result<ArrayResponse<Product>, Error>) in
                    switch result {
                    case .failure(let error):
                        completion(Result.failure(error))
                    case .success(let data):
                        completion(Result.success(data.response))
                    }
                }
            }
        }
        
    }
    
    /**
    Fetchs the summary of a vehicle
    
    - returns: A completion handler with a Vehicle.
    */
    public func getVehicle(_ vehicleID: String, completion: @escaping (Result<Vehicle, Error>) -> ()) -> Void {
        
        checkAuthentication { (result: Result<AuthToken, Error>) in
            
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                
                self.request(.vehicleSummary(vehicleID: vehicleID), body: nullBody) { (result: Result<Response<Vehicle>, Error>) in
                    switch result {
                    case .failure(let error):
                        completion(Result.failure(error))
                    case .success(let data):
                        completion(Result.success(data.response))
                    }
                }
            }
        }
        
    }
    
    /**
    Fetches the summary of a vehicle
    
    - returns: A completion handler with a Vehicle.
    */
    public func getVehicle(_ vehicle: Vehicle, completion: @escaping (Result<Vehicle, Error>) -> ()) -> Void {
        return getVehicle(vehicle.id!, completion: completion)
    }
	
    /**
     Fetches the vehicle data
     
     - returns: A completion handler with all the data
     */
	public func getAllData(_ vehicle: Vehicle, completion: @escaping (Result<VehicleExtended, Error>) -> ()) -> Void {
    
        checkAuthentication { (result: Result<AuthToken, Error>) in
            
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                
                let vehicleID = vehicle.id!
                
                self.request(.allStates(vehicleID: vehicleID), body: nullBody) { (result: Result<Response<VehicleExtended>, Error>) in
                    
                    switch result {
                    case .failure(let error):
                        completion(Result.failure(error))
                    case .success(let data):
                        completion(Result.success(data.response))
                    }
                }
            }
        }

	}
	
	/**
	Fetches the vehicle mobile access state
	
	- returns: A completion handler with mobile access state.
	*/
    public func getVehicleMobileAccessState(_ vehicle: Vehicle, completion: @escaping (Result<Bool, Error>) -> ()) -> Void {
        
        checkAuthentication { (result: Result<AuthToken, Error>) in
            
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                
                let vehicleID = vehicle.id!
                
                self.request(.mobileAccess(vehicleID: vehicleID), body: nullBody) { (result: Result<BoolResponse, Error>) in
                    
                    switch result {
                    case .failure(let error):
                        completion(Result.failure(error))
                    case .success(let data):
                        completion(Result.success(data.response))
                    }
                }
            }
        }
    }
    
	/**
	Fetches the vehicle charge state
	
	- returns: A completion handler with charge state.
	*/
	public func getVehicleChargeState(_ vehicle: Vehicle, completion: @escaping (Result<ChargeState, Error>) -> ()) -> Void {
        
        checkAuthentication { (result: Result<AuthToken, Error>) in
            
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                
                let vehicleID = vehicle.id!
                
                self.request(.chargeState(vehicleID: vehicleID), body: nullBody) { (result: Result<Response<ChargeState>, Error>) in
                    
                    switch result {
                    case .failure(let error):
                        completion(Result.failure(error))
                    case .success(let data):
                        completion(Result.success(data.response))
                    }
                }
            }
        }
		
	}
	
	/**
	Fetches the vehicle Climate state
	
	- returns: A completion handler with Climate state.
	*/
    public func getVehicleClimateState(_ vehicle: Vehicle, completion: @escaping (Result<ClimateState, Error>) -> ()) -> Void {
        
        checkAuthentication { (result: Result<AuthToken, Error>) in
            
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                
                let vehicleID = vehicle.id!
                
                self.request(.climateState(vehicleID: vehicleID), body: nullBody) { (result: Result<Response<ClimateState>, Error>) in
                    
                    switch result {
                    case .failure(let error):
                        completion(Result.failure(error))
                    case .success(let data):
                        completion(Result.success(data.response))
                    }
                }
            }
        }
  
	}
	
	/**
	Fetches the vehicle drive state
	
	- returns: A completion handler with drive state.
	*/
	public func getVehicleDriveState(_ vehicle: Vehicle, completion: @escaping (Result<DriveState, Error>) -> ()) -> Void {
        
        checkAuthentication { (result: Result<AuthToken, Error>) in
            
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                
                let vehicleID = vehicle.id!
                
                self.request(.driveState(vehicleID: vehicleID), body: nullBody) { (result: Result<Response<DriveState>,  Error>) in
                    
                    switch result {
                    case .failure(let error):
                        completion(Result.failure(error))
                    case .success(let data):
                        completion(Result.success(data.response))
                    }
                }
            }
        }
        
	}
	
	/**
	Fetches the vehicle GUI Settings
	
	- returns: A completion handler with GUI Settings.
	*/
    public func getVehicleGuiSettings(_ vehicle: Vehicle, completion: @escaping (Result<GuiSettings, Error>) -> ()) -> Void {
        
        checkAuthentication { (result: Result<AuthToken, Error>) in
            
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                
                let vehicleID = vehicle.id!
                
                self.request(.guiSettings(vehicleID: vehicleID), body: nullBody) { (result: Result<Response<GuiSettings>, Error>) in
                    
                    switch result {
                    case .failure(let error):
                        completion(Result.failure(error))
                    case .success(let data):
                        completion(Result.success(data.response))
                    }
                }
            }
        }
    }
	
	/**
	Fetches the vehicle state
	
	- returns: A completion handler with vehicle state.
	*/
    public func getVehicleState(_ vehicle: Vehicle, completion: @escaping (Result<VehicleState, Error>) -> ()) -> Void {
        
        checkAuthentication { (result: Result<AuthToken, Error>) in
            
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                
                let vehicleID = vehicle.id!
                
                self.request(.vehicleState(vehicleID: vehicleID), body: nullBody) { (result: Result<Response<VehicleState>, Error>) in
                    
                    switch result {
                    case .failure(let error):
                        completion(Result.failure(error))
                    case .success(let data):
                        completion(Result.success(data.response))
                    }
                }
            }
        }
        
    }
	
	/**
	Fetches the vehicle config
	
	- returns: A completion handler with vehicle config
	*/
    public func getVehicleConfig(_ vehicle: Vehicle, completion: @escaping (Result<VehicleConfig, Error>) -> ()) -> Void {
        
        checkAuthentication { (result: Result<AuthToken, Error>) in
            
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                
                let vehicleID = vehicle.id!
                
                self.request(.vehicleConfig(vehicleID: vehicleID), body: nullBody) { (result: Result<Response<VehicleConfig>, Error>) in
                    
                    switch result {
                    case .failure(let error):
                        completion(Result.failure(error))
                    case .success(let data):
                        completion(Result.success(data.response))
                    }
                }
            }
        }
    }

    /**
     Fetches the nearby charging sites

     - parameter vehicle: the vehicle to get nearby charging sites from
     - returns: A completion handler with nearby charging sites
     */
    public func getNearbyChargingSites(_ vehicle: Vehicle, completion: @escaping (Result<NearbyChargingSites, Error>) -> ()) -> Void {
        
        checkAuthentication { (result: Result<AuthToken, Error>) in
            
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                
                let vehicleID = vehicle.id!
                
                self.request(.nearbyChargingSites(vehicleID: vehicleID), body: nullBody) { (result: Result<Response<NearbyChargingSites>, Error>) in
                    
                    switch result {
                    case .failure(let error):
                        completion(Result.failure(error))
                    case .success(let data):
                        completion(Result.success(data.response))
                    }
                }
            }
        }
    }

	/**
	Wakes up the vehicle
	
	- returns: A completion handler with the current Vehicle
	*/
    public func wakeUp(_ vehicle: Vehicle, completion: @escaping (Result<Vehicle, Error>) -> ()) -> Void {
        
        checkAuthentication { (result: Result<AuthToken, Error>) in
            
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                
                let vehicleID = vehicle.id!
                
                self.request(.wakeUp(vehicleID: vehicleID), body: nullBody) { (result: Result<Response<Vehicle>, Error>) in
                    
                    switch result {
                    case .failure(let error):
                        completion(Result.failure(error))
                    case .success(let data):
                        completion(Result.success(data.response))
                    }
                }
            }
        }
		
	}
	
	/**
	Sends a command to the vehicle
	
	- parameter vehicle: the vehicle that will receive the command
	- parameter command: the command to send to the vehicle
	- returns: A completion handler with the CommandResponse object containing the results of the command.
	*/
	public func sendCommandToVehicle(_ vehicle: Vehicle, command: VehicleCommand, completion: @escaping (Result<CommandResponse, Error>) -> ()) -> Void {
		
        checkAuthentication { (result: Result<AuthToken, Error>) in
            
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                    switch command {
                        case let .setMaxDefrost(on: state):
                            let body = MaxDefrostCommandOptions(state: state)
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                        case let .triggerHomeLink(coordinates):
                            let body = HomeLinkCommandOptions(coordinates: coordinates)
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                        case let .valetMode(valetActivated, pin):
                            let body = ValetCommandOptions(valetActivated: valetActivated, pin: pin)
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                        case let .openTrunk(options):
                            let body = options
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                        case let .shareToVehicle(address):
                            let body = address
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                        case let .scheduledCharging(enable, time):
                            let body = ScheduledChargingCommandOptions(enable: enable, time: time)
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                        case let .scheduledDeparture(body):
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                        case let .chargeLimitPercentage(limit):
                            let body = ChargeLimitPercentageCommandOptions(limit: limit)
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                        case let .setTemperature(driverTemperature, passengerTemperature):
                            let body = SetTemperatureCommandOptions(driverTemperature: driverTemperature, passengerTemperature: passengerTemperature)
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                        case let .setSunRoof(state, percent):
                            let body = SetSunRoofCommandOptions(state: state, percent: percent)
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                        case let .startVehicle(password):
                            let body = RemoteStartDriveCommandOptions(password: password)
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                        case let .speedLimitSetLimit(speed):
                            let body = SetSpeedLimitOptions(limit: speed)
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                        case let .speedLimitActivate(pin):
                            let body = SpeedLimitPinOptions(pin: pin)
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                        case let .speedLimitDeactivate(pin):
                            let body = SpeedLimitPinOptions(pin: pin)
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                        case let .speedLimitClearPin(pin):
                            let body = SpeedLimitPinOptions(pin: pin)
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                        case let .setSeatHeater(seat, level):
                            let body = RemoteSeatHeaterRequestOptions(seat: seat, level: level)
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                        case let .setSteeringWheelHeater(on):
                            let body = RemoteSteeringWheelHeaterRequestOptions(on: on)
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                        case let .sentryMode(activated):
                            let body = SentryModeCommandOptions(activated: activated)
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                        case let .windowControl(state):
                            let body = WindowControlCommandOptions(command: state)
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                        case let .setCharging(amps):
                            let body = ChargeAmpsCommandOptions(amps: amps)
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                        default:
                            let body = nullBody
                            self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: completion)
                    }
            }
		
		}
		
	}
    
    
    /**
    Fetchs the status of your energy site
     
    - returns: A completion handler with an array of Products.
    */
    public func getEnergySiteStatus(siteID: String, completion: @escaping (Result<EnergySiteStatus, Error>) -> ()) -> Void {
        checkAuthentication { (result: Result<AuthToken, Error>) in
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                self.request(.getEnergySiteStatus(siteID: siteID), body: nullBody) { (result: Result<Response<EnergySiteStatus>, Error>) in
                    switch result {
                    case .failure(let error):
                        completion(Result.failure(error))
                    case .success(let data):
                        completion(Result.success(data.response))
                    }
                }
            }
        }
    }
    
    /**
     Fetchs the live status of your energy site
     
    - returns: A completion handler with an array of Products.
    */
    public func getEnergySiteLiveStatus(siteID: String, completion: @escaping (Result<EnergySiteLiveStatus, Error>) -> ()) -> Void {
        checkAuthentication { (result: Result<AuthToken, Error>) in
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                self.request(.getEnergySiteLiveStatus(siteID: siteID), body: nullBody) { (result: Result<Response<EnergySiteLiveStatus>, Error>) in
                    switch result {
                    case .failure(let error):
                        completion(Result.failure(error))
                    case .success(let data):
                        completion(Result.success(data.response))
                    }
                }
            }
        }
    }
    
    /**
     Fetchs the info of your energy site
     
    - returns: A completion handler with an array of Products.
    */
    public func getEnergySiteInfo(siteID: String, completion: @escaping (Result<EnergySiteInfo, Error>) -> ()) -> Void {
        checkAuthentication { (result: Result<AuthToken, Error>) in
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                self.request(.getEnergySiteInfo(siteID: siteID), body: nullBody) { (result: Result<Response<EnergySiteInfo>, Error>) in
                    switch result {
                    case .failure(let error):
                        completion(Result.failure(error))
                    case .success(let data):
                        completion(Result.success(data.response))
                    }
                }
            }
        }
    }
    
    /**
     Fetchs the history of your energy site
     
    - returns: A completion handler with an array of Products.
    */
    public func getEnergySiteHistory(siteID: String, period: EnergySiteHistory.Period, completion: @escaping (Result<EnergySiteHistory, Error>) -> ()) -> Void {
        checkAuthentication { (result: Result<AuthToken, Error>) in
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                self.request(.getEnergySiteHistory(siteID: siteID, period: period), body: nullBody) { (result: Result<Response<EnergySiteHistory>, Error>) in
                    switch result {
                    case .failure(let error):
                        completion(Result.failure(error))
                    case .success(let data):
                        completion(Result.success(data.response))
                    }
                }
            }
        }
    }
    
    /**
     Fetchs the status of your Powerwall battery
     
    - returns: A completion handler with an array of Products.
    */
    public func getBatteryStatus(batteryID: String, completion: @escaping (Result<BatteryStatus, Error>) -> ()) -> Void {
        checkAuthentication { (result: Result<AuthToken, Error>) in
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                self.request(.getBatteryStatus(batteryID: batteryID), body: nullBody) { (result: Result<Response<BatteryStatus>, Error>) in
                    switch result {
                    case .failure(let error):
                        completion(Result.failure(error))
                    case .success(let data):
                        completion(Result.success(data.response))
                    }
                }
            }
        }
    }
    
    /**
     Fetchs the data of your Powerwall battery
     
    - returns: A completion handler with an array of Products.
    */
    public func getBatteryData(batteryID: String, completion: @escaping (Result<BatteryData, Error>) -> ()) -> Void {
        checkAuthentication { (result: Result<AuthToken, Error>) in
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                self.request(.getBatteryData(batteryID: batteryID), body: nullBody) { (result: Result<Response<BatteryData>, Error>) in
                    switch result {
                    case .failure(let error):
                        completion(Result.failure(error))
                    case .success(let data):
                        completion(Result.success(data.response))
                    }
                }
            }
        }
    }
    
    /**
     Fetchs the history of your Powerwall battery
     
    - returns: A completion handler with an array of Products.
    */
    public func getBatteryPowerHistory(batteryID: String, completion: @escaping (Result<BatteryPowerHistory, Error>) -> ()) -> Void {
        checkAuthentication { (result: Result<AuthToken, Error>) in
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(_):
                self.request(.getBatteryPowerHistory(batteryID: batteryID), body: nullBody) { (result: Result<Response<BatteryPowerHistory>, Error>) in
                    switch result {
                    case .failure(let error):
                        completion(Result.failure(error))
                    case .success(let data):
                        completion(Result.success(data.response))
                    }
                }
            }
        }
    }
}

extension TeslaSwift {

    func checkToken() -> Bool {
        if let token = self.token {
            return token.isValid
        } else {
            return false
        }
    }

    func cleanToken()  {
        token = nil
    }

    func checkAuthentication() async throws -> AuthToken {
        guard let token = self.token else { throw TeslaError.authenticationRequired }

        if checkToken() {
            return token
        } else {
            if token.refreshToken != nil {
                return try await refreshWebToken()
            } else {
                throw TeslaError.authenticationRequired
            }
        }
	}

    private func request<ReturnType: Decodable, BodyType: Encodable>(
        _ endpoint: Endpoint, body: BodyType
    ) async throws -> ReturnType {
        let request = prepareRequest(endpoint, body: body)
        let debugEnabled = debuggingEnabled

        let data: Data
        let response: URLResponse

        if #available(iOS 15.0, *) {
            (data, response) = try await URLSession.shared.data(for: request)
        } else {
            (data, response) = try await withCheckedThrowingContinuation { continuation in
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data, let response = response {
                        continuation.resume(with: .success((data, response)))
                    } else {
                        continuation.resume(with: .failure(error ?? TeslaError.internalError))
                    }
                }
            }
        }

        guard let httpResponse = response as? HTTPURLResponse else { throw TeslaError.failedToParseData }

        var responseString = "\nRESPONSE: \(String(describing: httpResponse.url))"
        responseString += "\nSTATUS CODE: \(httpResponse.statusCode)"
        if let headers = httpResponse.allHeaderFields as? [String: String] {
            responseString += "\nHEADERS: [\n"
            headers.forEach {(key: String, value: String) in
                responseString += "\"\(key)\": \"\(value)\"\n"
            }
            responseString += "]"
        }

        logDebug(responseString, debuggingEnabled: debugEnabled)

        if case 200..<300 = httpResponse.statusCode {
            do {
                let objectString = String.init(data: data, encoding: String.Encoding.utf8) ?? "No Body"
                logDebug("RESPONSE BODY: \(objectString)\n", debuggingEnabled: debugEnabled)

                let mapped = try teslaJSONDecoder.decode(ReturnType.self, from: data)
                return mapped
            } catch {
                logDebug("ERROR: \(error)", debuggingEnabled: debugEnabled)
                throw TeslaError.failedToParseData
            }
        } else {
            let objectString = String.init(data: data, encoding: String.Encoding.utf8) ?? "No Body"
            logDebug("RESPONSE BODY ERROR: \(objectString)\n", debuggingEnabled: debugEnabled)
            if let wwwAuthenticate = httpResponse.allHeaderFields["Www-Authenticate"] as? String,
               wwwAuthenticate.contains("invalid_token") {
                throw TeslaError.tokenRevoked
            } else if httpResponse.allHeaderFields["Www-Authenticate"] != nil, httpResponse.statusCode == 401 {
                throw TeslaError.authenticationFailed
            } else if let mapped = try? teslaJSONDecoder.decode(ErrorMessage.self, from: data) {
                throw TeslaError.networkError(error: NSError(domain: "TeslaError", code: httpResponse.statusCode, userInfo:[ErrorInfo: mapped]))
            } else {
                throw TeslaError.networkError(error: NSError(domain: "TeslaError", code: httpResponse.statusCode, userInfo: nil))
            }
        }
    }

    func prepareRequest<BodyType: Encodable>(_ endpoint: Endpoint, body: BodyType) -> URLRequest {
        var urlComponents = URLComponents(url: URL(string: endpoint.baseURL())!, resolvingAgainstBaseURL: true)
        urlComponents?.path = endpoint.path
        urlComponents?.queryItems = endpoint.queryParameters
        var request = URLRequest(url: urlComponents!.url!)
		request.httpMethod = endpoint.method
		
		request.setValue("TeslaSwift", forHTTPHeaderField: "User-Agent")
		
		if let token = self.token?.accessToken {
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}
		
		if let body = body as? String, body == nullBody {
            // Shrug
		} else {
			request.httpBody = try? teslaJSONEncoder.encode(body)
			request.setValue("application/json", forHTTPHeaderField: "content-type")
		}
		
		logDebug("\nREQUEST: \(request)", debuggingEnabled: debuggingEnabled)
		logDebug("METHOD: \(request.httpMethod!)", debuggingEnabled: debuggingEnabled)
		if let headers = request.allHTTPHeaderFields {
			var headersString = "REQUEST HEADERS: [\n"
			headers.forEach {(key: String, value: String) in
				headersString += "\"\(key)\": \"\(value)\"\n"
			}
			headersString += "]"
			logDebug(headersString, debuggingEnabled: debuggingEnabled)
		}
		
		if let body = body as? String, body != nullBody {
            // Shrug
		} else if let jsonString = body.jsonString {
			logDebug("REQUEST BODY: \(jsonString)", debuggingEnabled: debuggingEnabled)
		}
		
		return request
	}
	
}

func logDebug(_ format: String, debuggingEnabled: Bool) {
	if debuggingEnabled {
		print(format)
	}
}

public let teslaJSONEncoder: JSONEncoder = {
	let encoder = JSONEncoder()
	encoder.outputFormatting = .prettyPrinted
	encoder.dateEncodingStrategy = .secondsSince1970
	return encoder
}()

public let teslaJSONDecoder: JSONDecoder = {
	let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            if let dateDouble = try? container.decode(Double.self) {
                return Date(timeIntervalSince1970: dateDouble)
            } else {
                let dateString = try container.decode(String.self)
                let dateFormatter = ISO8601DateFormatter()
                var date = dateFormatter.date(from: dateString)
                guard let date = date else {
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
                }
                return date
            }
        })
	return decoder
}()
