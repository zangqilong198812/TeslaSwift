//
//  TeslaSwift.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 04/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import os.log

public enum RoofState: String, Codable {
	case close
	case vent
}

public enum VehicleCommand {
	case valetMode(valetActivated: Bool, pin: String?)
	case resetValetPin
	case openChargeDoor
	case closeChargeDoor
	case chargeLimitStandard
	case chargeLimitMaxRange
	case chargeLimitPercentage(limit: Int)
	case startCharging
	case stopCharging
	case flashLights
	case honkHorn
	case unlockDoors
	case lockDoors
	case setTemperature(driverTemperature: Double, passengerTemperature: Double)
	case startAutoConditioning
	case stopAutoConditioning
	case setSunRoof(state: RoofState, percentage: Int?)
	case startVehicle(password: String)
	case openTrunk(options: OpenTrunkOptions)
	case togglePlayback
	case nextTrack
	case previousTrack
	case nextFavorite
	case previousFavorite
	case volumeUp
	case volumeDown
	case navigationRequest(options: NavigationRequestOptions)
	case cancelSoftwareUpdate
	case scheduleSoftwareUpdate
	case speedLimitSetLimit(speed: Measurement<UnitSpeed>)
	case speedLimitActivate(pin: String)
	case speedLimitDeactivate(pin: String)
	case speedLimitClearPin(pin: String)
	case setSeatHeater(seat: HeatedSeat, level: HeatLevel)
	case setSteeringWheelHeater(on: Bool)
	case sentryMode(activated: Bool)
	
	func path() -> String {
		switch self {
		case .valetMode:
			return "command/set_valet_mode"
		case .resetValetPin:
			return "command/reset_valet_pin"
		case .openChargeDoor:
			return "command/charge_port_door_open"
		case .closeChargeDoor:
			return "command/charge_port_door_close"
		case .chargeLimitStandard:
			return "command/charge_standard"
		case .chargeLimitMaxRange:
			return "command/charge_max_range"
		case .chargeLimitPercentage:
			return  "command/set_charge_limit"
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
		case .setTemperature:
			return "command/set_temps"
		case .startAutoConditioning:
			return "command/auto_conditioning_start"
		case .stopAutoConditioning:
			return "command/auto_conditioning_stop"
		case .setSunRoof:
			return "command/sun_roof_control"
		case .startVehicle:
			return "command/remote_start_drive"
		case .openTrunk:
			return "command/actuate_trunk"
		case .togglePlayback:
			return "command/media_toggle_playback"
		case .nextTrack:
			return "command/media_next_track"
		case .previousTrack:
			return "command/media_prev_track"
		case .nextFavorite:
			return "command/media_next_fav"
		case .previousFavorite:
			return "command/media_prev_fav"
		case .volumeUp:
			return "command/media_volume_up"
		case .volumeDown:
			return "command/media_volume_down"
		case .navigationRequest:
            		return "command/navigation_request"
		case .scheduleSoftwareUpdate:
            		return "command/schedule_software_update"
		case .cancelSoftwareUpdate:
            		return "command/cancel_software_update"
		case .speedLimitSetLimit:
			return "command/speed_limit_set_limit"
		case .speedLimitActivate:
			return "command/speed_limit_activate"
		case .speedLimitDeactivate:
			return "command/speed_limit_deactivate"
		case .speedLimitClearPin:
			return "command/speed_limit_clear_pin"
		case .setSeatHeater:
			return "command/remote_seat_heater_request"
		case .setSteeringWheelHeater:
			return "command/remote_steering_wheel_heater_request"
		case .sentryMode:
			return "command/set_sentry_mode"
		}
	}
}

public enum TeslaError: Error, Equatable {
	case networkError(error:NSError)
	case authenticationRequired
	case authenticationFailed
	case tokenRevoked
	case invalidOptionsForCommand
	case failedToParseData
	case streamingMissingEmailOrVehicleToken
}

let ErrorInfo = "ErrorInfo"
private var nullBody = ""

open class TeslaSwift {
	
	open var useMockServer = false
	open var debuggingEnabled = false {
		didSet {
			streaming.debuggingEnabled = debuggingEnabled
		}
	}
	
	open fileprivate(set) var token: AuthToken?
	
    open fileprivate(set) var email: String?
	fileprivate var password: String?
	lazy var streaming = TeslaStreaming()
	
	public init() { }
}

extension TeslaSwift {
	
	public var isAuthenticated: Bool {
		return token != nil && (token?.isValid ?? false)
	}
	
	/**
	Performs the authentition with the Tesla API
	
	You only need to call this once. The token will be stored and your credentials.
	If the token expires your credentials will be reused.
	
	- parameter email:      The email address.
	- parameter password:   The password.
	
	- returns: A completion handler with the AuthToken.
	*/

    public func authenticate(email: String, password: String, completion: @escaping (AuthToken?, Error?) -> ()) -> Void {
		
		self.email = email
        UserDefaults.standard.set(email, forKey: "TeslaSwift.email")
		self.password = password

		let body = AuthTokenRequest(email: email,
		                            password: password,
		                            grantType: "password",
		                            clientID: "81527cff06843c8634fdc09e8ac0abefb46ac849f38fe1e431c2ef2106796384",
		                            clientSecret: "c7257eb71a564034f9419ee651c7d0e5f7aa6bfbd18bafb5c5c033b093bb2fa3")
		
        
        request(.authentication, body: body) { (result: AuthToken?, error: Error?) in
            
            if let result = result {
                self.token = result
                completion(result, nil)
            } else if let error = error {
                if case let TeslaError.networkError(error: internalError) = error {
                    if internalError.code == 401 {
                        completion(nil, TeslaError.authenticationFailed)
                    } else {
                        completion(nil, error)
                    }
                } else {
                    completion(nil, error)
                }
            } else {
                // not possible
            }
        }
        
	}
	
	
	/**
	Use this method to reuse a previous authentication token
	
	This method is useful if your app wants to ask the user for credentials once and reuse the token skiping authentication
	If the token is invalid a new authentication will be required
	
	- parameter token:      The previous token
	- parameter email:      Email is required for streaming
	*/
	public func reuse(token: AuthToken, email: String? = nil) {
		self.token = token
		self.email = email
	}
	
	/**
	Revokes the stored token. Endpoint always returns true.
	
	- returns: A completion handler with the token revoke state.
	*/
	public func revoke(completion: @escaping (Bool?, Error?) -> ()) -> Void {
		
		guard let accessToken = self.token?.accessToken else {
			token = nil
			return completion(false, nil)
		}
			
		token = nil
		
        checkAuthentication { (token, error) in
            
            let body = ["token" : accessToken]
            self.token = nil
            
            if error != nil {
                completion(nil, error)
            } else {
                
                self.request(.revoke, body: body) { (data: BoolResponse?, error: Error?) in
                    
                    guard let data = data else {
                        completion(nil, error)
                        return
                    }
                    
                    completion(data.response, error)
                }
            }
        }
        

	}
	
	/**
	Removes all the information related to the previous authentication
	
	*/
	public func logout() {
		email = nil
		password = nil
		token = nil
	}
	
	/**
	Fetchs the list of your vehicles including not yet delivered ones
	
	- returns: A completion handler with an array of Vehicles.
	*/
	public func getVehicles(completion: @escaping ([Vehicle]?, Error?) -> ()) -> Void {
		
        checkAuthentication { (token: AuthToken?, error: Error?) in
            
            if error != nil {
                completion(nil, error)
            } else {
                
                self.request(.vehicles, body: nullBody) { (data: ArrayResponse<Vehicle>?, error: Error?) in
                    guard let data = data else {
                        completion(nil, error)
                        return
                    }
                    
                    completion(data.response, error)
                }
            }
        }
		
	}
	
    /**
     Fetchs the vehicle data
     
     - returns: A completion handler with all the data
     */
	public func getAllData(_ vehicle: Vehicle, completion: @escaping (VehicleExtended?, Error?) -> ()) -> Void {
    
        checkAuthentication { (token: AuthToken?, error: Error?) in
            
            if error != nil {
                completion(nil, error)
            } else {
                
                let vehicleID = vehicle.id!
                
                self.request(.allStates(vehicleID: vehicleID), body: nullBody) { (data: Response<VehicleExtended>?, error: Error?) in
                    
                    guard let data = data else {
                        completion(nil, error)
                        return
                    }
                    
                    completion(data.response, error)
                }
            }
        }

	}
	
	/**
	Fetchs the vehicle mobile access state
	
	- returns: A completion handler with mobile access state.
	*/
	public func getVehicleMobileAccessState(_ vehicle: Vehicle, completion: @escaping (Bool?, Error?) -> ()) -> Void {
		
        checkAuthentication { (token: AuthToken?, error: Error?) in
            
            if error != nil {
                completion(nil, error)
            } else {
                
                let vehicleID = vehicle.id!
                
                self.request(.mobileAccess(vehicleID: vehicleID), body: nullBody) { (data: BoolResponse?, error: Error?) in
                    
                    guard let data = data else {
                        completion(nil, error)
                        return
                    }
                    
                    completion(data.response, error)
                }
            }
        }
    }
    
	/**
	Fetchs the vehicle charge state
	
	- returns: A completion handler with charge state.
	*/
	public func getVehicleChargeState(_ vehicle: Vehicle, completion: @escaping (ChargeState?, Error?) -> ()) -> Void {
		
        checkAuthentication { (token: AuthToken?, error: Error?) in
            
            if error != nil {
                completion(nil, error)
            } else {
                
                let vehicleID = vehicle.id!
                
                self.request(.chargeState(vehicleID: vehicleID), body: nullBody) { (data: Response<ChargeState>?, error: Error?) in
                    
                    guard let data = data else {
                        completion(nil, error)
                        return
                    }
                    
                    completion(data.response, error)
                }
            }
        }
		
	}
	
	/**
	Fetchs the vehicle Climate state
	
	- returns: A completion handler with Climate state.
	*/
	public func getVehicleClimateState(_ vehicle: Vehicle, completion: @escaping (ClimateState?, Error?) -> ()) -> Void {
		
        checkAuthentication { (token: AuthToken?, error: Error?) in
            
            if error != nil {
                completion(nil, error)
            } else {
                
                let vehicleID = vehicle.id!
                
                self.request(.climateState(vehicleID: vehicleID), body: nullBody) { (data: Response<ClimateState>?, error: Error?) in
                    
                    guard let data = data else {
                        completion(nil, error)
                        return
                    }
                    
                    completion(data.response, error)
                }
            }
        }
  
	}
	
	/**
	Fetchs the vehicledrive state
	
	- returns: A completion handler with drive state.
	*/
	public func getVehicleDriveState(_ vehicle: Vehicle, completion: @escaping (DriveState?, Error?) -> ()) -> Void {
		
        checkAuthentication { (token: AuthToken?, error: Error?) in
            
            if error != nil {
                completion(nil, error)
            } else {
                
                let vehicleID = vehicle.id!
                
                self.request(.driveState(vehicleID: vehicleID), body: nullBody) { (data: Response<DriveState>?, error: Error?) in
                    
                    guard let data = data else {
                        completion(nil, error)
                        return
                    }
                    
                    completion(data.response, error)
                }
            }
        }
       
	}
	
	/**
	Fetchs the vehicle Gui Settings
	
	- returns: A completion handler with Gui Settings.
	*/
    public func getVehicleGuiSettings(_ vehicle: Vehicle, completion: @escaping (GuiSettings?, Error?) -> ()) -> Void {
        
        checkAuthentication { (token: AuthToken?, error: Error?) in
            
            if error != nil {
                completion(nil, error)
            } else {
                
                let vehicleID = vehicle.id!
                
                self.request(.guiSettings(vehicleID: vehicleID), body: nullBody) { (data: Response<GuiSettings>?, error: Error?) in
                    
                    guard let data = data else {
                        completion(nil, error)
                        return
                    }
                    
                    completion(data.response, error)
                }
            }
        }
	}
	
	/**
	Fetchs the vehicle state
	
	- returns: A completion handler with vehicle state.
	*/
    public func getVehicleState(_ vehicle: Vehicle, completion: @escaping (VehicleState?, Error?) -> ()) -> Void {
        
        checkAuthentication { (token: AuthToken?, error: Error?) in
            
            if error != nil {
                completion(nil, error)
            } else {
                
                let vehicleID = vehicle.id!
                
                self.request(.vehicleState(vehicleID: vehicleID), body: nullBody) { (data: Response<VehicleState>?, error: Error?) in
                    
                    guard let data = data else {
                        completion(nil, error)
                        return
                    }
                    
                    completion(data.response, error)
                }
            }
        }

	}
	
	/**
	Fetchs the vehicle config
	
	- returns: A completion handler with vehicle config
	*/
    public func getVehicleConfig(_ vehicle: Vehicle, completion: @escaping (VehicleConfig?, Error?) -> ()) -> Void {
        
        checkAuthentication { (token: AuthToken?, error: Error?) in
            
            if error != nil {
                completion(nil, error)
            } else {
                
                let vehicleID = vehicle.id!
                
                self.request(.vehicleConfig(vehicleID: vehicleID), body: nullBody) { (data: Response<VehicleConfig>?, error: Error?) in
                    
                    guard let data = data else {
                        completion(nil, error)
                        return
                    }
                    
                    completion(data.response, error)
                }
            }
        }
	}

    /**
     Fetches the nearby charging sites

     - parameter vehicle: the vehicle to get nearby charging sites from
     - returns: A completion handler with nearby charging sites
     */
    public func getNearbyChargingSites(_ vehicle: Vehicle, completion: @escaping (NearbyChargingSites?, Error?) -> ()) -> Void {
        
        checkAuthentication { (token: AuthToken?, error: Error?) in
            
            if error != nil {
                completion(nil, error)
            } else {
                
                let vehicleID = vehicle.id!
                
                self.request(.nearbyChargingSites(vehicleID: vehicleID), body: nullBody) { (data: Response<NearbyChargingSites>?, error: Error?) in
                    
                    guard let data = data else {
                        completion(nil, error)
                        return
                    }
                    
                    completion(data.response, error)
                }
            }
        }
    }

	/**
	Wakes up the vehicle
	
	- returns: A completion handler with the current Vehicle
	*/
    public func wakeUp(_ vehicle: Vehicle, completion: @escaping (Vehicle?, Error?) -> ()) -> Void {
        
        checkAuthentication { (token: AuthToken?, error: Error?) in
            
            if error != nil {
                completion(nil, error)
            } else {
                
                let vehicleID = vehicle.id!
                
                self.request(.wakeUp(vehicleID: vehicleID), body: nullBody) { (data: Response<Vehicle>?, error: Error?) in
                    
                    guard let data = data else {
                        completion(nil, error)
                        return
                    }
                    
                    completion(data.response, error)
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
	public func sendCommandToVehicle(_ vehicle: Vehicle, command: VehicleCommand, completion: @escaping (CommandResponse?, Error?) -> ()) -> Void {
		
        checkAuthentication { (token: AuthToken?, error: Error?) in
            
            if error != nil {
                completion(nil, error)
            } else {
                
                let requestCompletion = { (data: CommandResponse?, error: Error?) in
                    
                    guard let data = data else {
                        completion(nil, error)
                        return
                    }
                    
                    completion(data, error)
                }
                
    			switch command {
				case let .valetMode(valetActivated, pin):
                    let body = ValetCommandOptions(valetActivated: valetActivated, pin: pin)
                    self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: requestCompletion)
				case let .openTrunk(options):
					let body = options
					self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: requestCompletion)
                case let .navigationRequest(address):
                    let body = address
                    self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: requestCompletion)
				case let .chargeLimitPercentage(limit):
					let body = ChargeLimitPercentageCommandOptions(limit: limit)
					self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: requestCompletion)
				case let .setTemperature(driverTemperature, passengerTemperature):
					 let body = SetTemperatureCommandOptions(driverTemperature: driverTemperature, passengerTemperature: passengerTemperature)
					self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: requestCompletion)
				case let .setSunRoof(state, percent):
					 let body = SetSunRoofCommandOptions(state: state, percent: percent)
					self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: requestCompletion)
				case let .startVehicle(password):
					 let body = RemoteStartDriveCommandOptions(password: password)
					self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: requestCompletion)
				case let .speedLimitSetLimit(speed):
					 let body = SetSpeedLimitOptions(limit: speed)
                     self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: requestCompletion)
				case let .speedLimitActivate(pin):
					 let body = SpeedLimitPinOptions(pin: pin)
					 self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: requestCompletion)
				case let .speedLimitDeactivate(pin):
					 let body = SpeedLimitPinOptions(pin: pin)
					 self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: requestCompletion)
				case let .speedLimitClearPin(pin):
					 let body = SpeedLimitPinOptions(pin: pin)
					 self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: requestCompletion)
                case let .setSeatHeater(seat, level):
                     let body = RemoteSeatHeaterRequestOptions(seat: seat, level: level)
                     self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: requestCompletion)
                case let .setSteeringWheelHeater(on):
                     let body = RemoteSteeringWheelHeaterRequestOptions(on: on)
                     self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: requestCompletion)
                case let .sentryMode(activated):
                     let body = SentryModeCommandOptions(activated: activated)
                     self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: requestCompletion)
				default:
                    let body = nullBody
					self.request(Endpoint.command(vehicleID: vehicle.id!, command: command), body: body, completion: requestCompletion)
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
		self.token = nil
	}
	
    func checkAuthentication(completion: @escaping (AuthToken?, Error?) -> ()) {

        let value = checkToken()
        
        if value {
            completion(self.token!, nil)
        } else {
            self.cleanToken()
            if let email = self.email, let password = self.password {
                authenticate(email: email, password: password, completion: completion)
            } else {
                completion(nil, TeslaError.authenticationRequired)
            }
        }
	}
	
    func request<ReturnType: Decodable, BodyType: Encodable>(_ endpoint: Endpoint, body: BodyType, completion: @escaping (ReturnType?, Error?) -> ()) -> Void {
		
		let request = prepareRequest(endpoint, body: body)
		let debugEnabled = debuggingEnabled
		let task = URLSession.shared.dataTask(with: request, completionHandler: {
			(data, response, error) in
			
			
			guard error == nil else { completion(nil, error!); return }
			guard let httpResponse = response as? HTTPURLResponse else { completion(nil, TeslaError.failedToParseData); return }
			
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
					if let data = data {
						let objectString = String.init(data: data, encoding: String.Encoding.utf8) ?? "No Body"
						logDebug("RESPONSE BODY: \(objectString)\n", debuggingEnabled: debugEnabled)
						
						let mapped = try teslaJSONDecoder.decode(ReturnType.self, from: data)
                        completion(mapped, nil)
					}
				} catch {
					logDebug("ERROR: \(error)", debuggingEnabled: debugEnabled)
					completion(nil, TeslaError.failedToParseData)
				}
				
			} else {
				if let data = data {
					
					let objectString = String.init(data: data, encoding: String.Encoding.utf8) ?? "No Body"
					logDebug("RESPONSE BODY ERROR: \(objectString)\n", debuggingEnabled: debugEnabled)
					
					if let wwwauthenticate = httpResponse.allHeaderFields["Www-Authenticate"] as? String,
						wwwauthenticate.contains("invalid_token") {
						completion(nil, TeslaError.tokenRevoked)
					} else if let mapped = try? teslaJSONDecoder.decode(ErrorMessage.self, from: data) {
						completion(nil, TeslaError.networkError(error: NSError(domain: "TeslaError", code: httpResponse.statusCode, userInfo:[ErrorInfo: mapped])))
					} else {
						completion(nil, TeslaError.networkError(error: NSError(domain: "TeslaError", code: httpResponse.statusCode, userInfo: nil)))
					}
					
				} else {
					if let wwwauthenticate = httpResponse.allHeaderFields["Www-Authenticate"] as? String {
						if wwwauthenticate.contains("invalid_token") {
							completion(nil, TeslaError.authenticationFailed)
						}
					} else {
						completion(nil, TeslaError.networkError(error: NSError(domain: "TeslaError", code: httpResponse.statusCode, userInfo: nil)))
					}
				}
			}
			
			
		}) 
		task.resume()
		
	}

	func prepareRequest<BodyType: Encodable>(_ endpoint: Endpoint, body: BodyType) -> URLRequest {
	
		var request = URLRequest(url: URL(string: endpoint.baseURL(useMockServer) + endpoint.path)!)
		request.httpMethod = endpoint.method
		
		request.setValue("TeslaSwift", forHTTPHeaderField: "User-Agent")
		
		if let token = self.token?.accessToken {
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}
		
		if let body = body as? String, body == nullBody {
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
		} else if let jsonString = body.jsonString {
			logDebug("REQUEST BODY: \(jsonString)", debuggingEnabled: debuggingEnabled)
		}
		
		return request
	}
	
}

// MARK: Streaming API
extension TeslaSwift {
	
	/**
	Streams vehicle data
	
	- parameter vehicle: the vehicle that will receive the command
	- parameter reloadsVehicle: if you have a cached vehicle, the token might be expired, this forces a vehicle token reload
	- parameter dataReceived: callback to receive the websocket data
	*/
	public func openStream(vehicle: Vehicle, reloadsVehicle: Bool = true, dataReceived: @escaping ((event: StreamEvent?, error: Error?)) -> Void) {
		
		if reloadsVehicle {
			
            reloadVehicle(vehicle: vehicle) { (freshVehicle: Vehicle?, error: Error?) in
                if let freshVehicle = freshVehicle {
                    self.startStream(vehicle: freshVehicle, dataReceived: dataReceived)
                } else {
                    dataReceived((event: nil, error: error))
                }
            }
			
		} else {
			startStream(vehicle: vehicle, dataReceived: dataReceived)
		}
	
	}
	
	func reloadVehicle(vehicle: Vehicle, completion: @escaping (Vehicle?, Error?) -> ()) -> Void {
        
        getVehicles { (vehicles: [Vehicle]?, error: Error?) in
            
            guard let vehicles = vehicles else {
                completion(nil, error)
                return
            }
            
            for freshVehicle in vehicles where freshVehicle.vehicleID == vehicle.vehicleID {
                completion(freshVehicle, error)
                return
            }
            
            completion(vehicle, error)
        }
        
	}
	
	func startStream(vehicle: Vehicle, dataReceived: @escaping ((event: StreamEvent?, error: Error?)) -> Void) {
		guard let email = email,
			let vehicleToken = vehicle.tokens?.first else {
				dataReceived((nil, TeslaError.streamingMissingEmailOrVehicleToken))
				return
		}
		
		let endpoint = StreamEndpoint.stream(email: email, vehicleToken: vehicleToken, vehicleId: "\(vehicle.vehicleID!)")
		
		streaming.openStream(endpoint: endpoint, dataReceived: dataReceived)
	}

	/**
	Stops the stream
	*/
	public func closeStream() {
		streaming.closeStream()
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
	decoder.dateDecodingStrategy = .secondsSince1970
	return decoder
}()
