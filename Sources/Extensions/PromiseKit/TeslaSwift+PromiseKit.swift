//
//  TeslaSwift+PromiseKit.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 09/07/2019.
//  Copyright © 2019 Joao Nunes. All rights reserved.
//

import Foundation
import PromiseKit
#if COCOAPODS
#else // SPM
import TeslaSwift
#endif

extension TeslaSwift {
    /**
     Revokes the stored token. Endpoint always returns true.
     
     - returns: A Promise with the token revoke state.
     */
    public func revokeWeb() -> Promise<Bool> {
        let (promise, seal) = Promise<Bool>.pending()
        Task {
            do {
                let result = try await self.revokeWeb()
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }
    
    /**
     Fetchs the list of your vehicles including not yet delivered ones
     
     - returns: A Promise with an array of Vehicles.
     */
    public func getVehicles() -> Promise<[Vehicle]> {
        let (promise, seal) = Promise<[Vehicle]>.pending()
        Task {
            do {
                let result = try await self.getVehicles()
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }

    public func getVehicle(_ vehicleID: String) -> Promise<Vehicle> {
        let (promise, seal) = Promise<Vehicle>.pending()
        Task {
            do {
                let result = try await self.getVehicle(vehicleID)
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }
    
    public func getVehicle(_ vehicle: Vehicle) -> Promise<Vehicle> {
        let (promise, seal) = Promise<Vehicle>.pending()
        Task {
            do {
                let result = try await self.getVehicle(vehicle)
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }
    
    public func getAllData(_ vehicle: Vehicle) -> Promise<VehicleExtended> {
        let (promise, seal) = Promise<VehicleExtended>.pending()
        Task {
            do {
                let result = try await self.getAllData(vehicle)
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }
    
    public func getVehicleMobileAccessState(_ vehicle: Vehicle) -> Promise<Bool> {
        let (promise, seal) = Promise<Bool>.pending()
        Task {
            do {
                let result = try await self.getVehicleMobileAccessState(vehicle)
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }
    
    /**
     Fetchs the vehicle charge state
     
     - returns: A Promise with charge state.
     */
    public func getVehicleChargeState(_ vehicle: Vehicle) -> Promise<ChargeState> {
        let (promise, seal) = Promise<ChargeState>.pending()
        Task {
            do {
                let result = try await self.getVehicleChargeState(vehicle)
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }
    
    /**
     Fetchs the vehicle Climate state
     
     - returns: A Promise with Climate state.
     */
    public func getVehicleClimateState(_ vehicle: Vehicle) -> Promise<ClimateState> {
        let (promise, seal) = Promise<ClimateState>.pending()
        Task {
            do {
                let result = try await self.getVehicleClimateState(vehicle)
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }
    
    /**
     Fetchs the vehicledrive state
     
     - returns: A Promise with drive state.
     */
    public func getVehicleDriveState(_ vehicle: Vehicle) -> Promise<DriveState> {
        let (promise, seal) = Promise<DriveState>.pending()
        Task {
            do {
                let result = try await self.getVehicleDriveState(vehicle)
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }
    
    /**
     Fetchs the vehicle Gui Settings
     
     - returns: A Promise with Gui Settings.
     */
    public func getVehicleGuiSettings(_ vehicle: Vehicle) -> Promise<GuiSettings> {
        let (promise, seal) = Promise<GuiSettings>.pending()
        Task {
            do {
                let result = try await self.getVehicleGuiSettings(vehicle)
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }
    
    /**
     Fetchs the vehicle state
     
     - returns: A Promise with vehicle state.
     */
    public func getVehicleState(_ vehicle: Vehicle) -> Promise<VehicleState> {
        let (promise, seal) = Promise<VehicleState>.pending()
        Task {
            do {
                let result = try await self.getVehicleState(vehicle)
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }
    
    /**
     Fetchs the vehicle config
     
     - returns: A Promise with vehicle config
     */
    public func getVehicleConfig(_ vehicle: Vehicle) -> Promise<VehicleConfig> {
        let (promise, seal) = Promise<VehicleConfig>.pending()
        Task {
            do {
                let result = try await self.getVehicleConfig(vehicle)
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }
    
    /**
     Fetches the nearby charging sites
     
     - parameter vehicle: the vehicle to get nearby charging sites from
     - returns: A Promise with nearby charging sites
     */
    public func getNearbyChargingSites(_ vehicle: Vehicle) -> Promise<NearbyChargingSites> {
        let (promise, seal) = Promise<NearbyChargingSites>.pending()
        Task {
            do {
                let result = try await self.getNearbyChargingSites(vehicle)
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
        
    }
    
    /**
     Wakes up the vehicle
     
     - returns: A Promise with the current Vehicle
     */
    public func wakeUp(vehicle: Vehicle) -> Promise<Vehicle> {
        let (promise, seal) = Promise<Vehicle>.pending()
        Task {
            do {
                let result = try await self.wakeUp(vehicle)
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }
    
    /**
     Sends a command to the vehicle
     
     - parameter vehicle: the vehicle that will receive the command
     - parameter command: the command to send to the vehicle
     - returns: A Promise with the CommandResponse object containing the results of the command.
     */
    public func sendCommandToVehicle(_ vehicle: Vehicle, command: VehicleCommand) -> Promise<CommandResponse> {
        let (promise, seal) = Promise<CommandResponse>.pending()
        Task {
            do {
                let result = try await self.sendCommandToVehicle(vehicle, command: command)
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }
    
    public func getProducts() -> Promise<[Product]> {
        let (promise, seal) = Promise<[Product]>.pending()
        Task {
            do {
                let result = try await self.getProducts()
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }
        
    public func getEnergySiteStatus(siteID: String) -> Promise<EnergySiteStatus> {
        let (promise, seal) = Promise<EnergySiteStatus>.pending()
        Task {
            do {
                let result = try await self.getEnergySiteStatus(siteID: siteID)
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }

    public func getEnergySiteLiveStatus(siteID: String) -> Promise<EnergySiteLiveStatus> {
        let (promise, seal) = Promise<EnergySiteLiveStatus>.pending()
        Task {
            do {
                let result = try await self.getEnergySiteLiveStatus(siteID: siteID)
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }

    public func getEnergySiteInfo(siteID: String) -> Promise<EnergySiteInfo> {
        let (promise, seal) = Promise<EnergySiteInfo>.pending()
        Task {
            do {
                let result = try await self.getEnergySiteInfo(siteID: siteID)
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }

    public func getEnergySiteHistory(siteID: String, period: EnergySiteHistory.Period) -> Promise<EnergySiteHistory> {
        let (promise, seal) = Promise<EnergySiteHistory>.pending()
        Task {
            do {
                let result = try await self.getEnergySiteHistory(siteID: siteID, period: period)
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }

    public func getBatteryStatus(batteryID: String) -> Promise<BatteryStatus> {
        let (promise, seal) = Promise<BatteryStatus>.pending()
        Task {
            do {
                let result = try await self.getBatteryStatus(batteryID: batteryID)
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }

    public func getBatteryData(batteryID: String) -> Promise<BatteryData> {
        let (promise, seal) = Promise<BatteryData>.pending()
        Task {
            do {
                let result = try await self.getBatteryData(batteryID: batteryID)
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }

    public func getBatteryPowerHistory(batteryID: String) -> Promise<BatteryPowerHistory> {
        let (promise, seal) = Promise<BatteryPowerHistory>.pending()
        Task {
            do {
                let result = try await self.getBatteryPowerHistory(batteryID: batteryID)
                seal.fulfill(result)
            } catch let error {
                seal.reject(error)
            }
        }
        return promise
    }
}
