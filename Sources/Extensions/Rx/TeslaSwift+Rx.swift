//
//  TeslaSwift+Combine.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 08/07/2019.
//  Copyright © 2019 Joao Nunes. All rights reserved.
//

import Foundation
import RxSwift
#if COCOAPODS
#else // SPM
import TeslaSwift
#endif

extension TeslaSwift {
    public func revokeWeb() -> Single<Bool> {
        let future = Single<Bool>.create { (single: @escaping (SingleEvent<Bool>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await self.revokeWeb()
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }
    
    public func getVehicles() -> Single<[Vehicle]> {
        let future = Single<[Vehicle]>.create { (single: @escaping (SingleEvent<[Vehicle]>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await self.getVehicles()
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }
    
    public func getVehicle(_ vehicleID: String) -> Single<Vehicle> {
        let future = Single<Vehicle>.create { (single: @escaping (SingleEvent<Vehicle>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await self.getVehicle(vehicleID)
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }
    
    public func getVehicle(_ vehicle: Vehicle) -> Single<Vehicle> {
        let future = Single<Vehicle>.create { (single: @escaping (SingleEvent<Vehicle>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await self.getVehicle(vehicle)
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }
    
    public func getAllData(_ vehicle: Vehicle) -> Single<VehicleExtended> {
        let future = Single<VehicleExtended>.create { (single: @escaping (SingleEvent<VehicleExtended>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await self.getAllData(vehicle)
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }
    
    public func getVehicleMobileAccessState(_ vehicle: Vehicle) -> Single<Bool> {
        let future = Single<Bool>.create { (single: @escaping (SingleEvent<Bool>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await self.getVehicleMobileAccessState(vehicle)
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }
    
    public func getVehicleChargeState(_ vehicle: Vehicle) -> Single<ChargeState> {
        let future = Single<ChargeState>.create { (single: @escaping (SingleEvent<ChargeState>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await self.getVehicleChargeState(vehicle)
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }
    
    public func getVehicleClimateState(_ vehicle: Vehicle) -> Single<ClimateState> {
        let future = Single<ClimateState>.create { (single: @escaping (SingleEvent<ClimateState>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await self.getVehicleClimateState(vehicle)
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }
    
    public func getVehicleDriveState(_ vehicle: Vehicle) -> Single<DriveState> {
        let future = Single<DriveState>.create { (single: @escaping (SingleEvent<DriveState>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await self.getVehicleDriveState(vehicle)
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }
    
    public func getVehicleGuiSettings(_ vehicle: Vehicle) -> Single<GuiSettings> {
        let future = Single<GuiSettings>.create { (single: @escaping (SingleEvent<GuiSettings>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await self.getVehicleGuiSettings(vehicle)
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }
    
    public func getVehicleState(_ vehicle: Vehicle) -> Single<VehicleState> {
        let future = Single<VehicleState>.create { (single: @escaping (SingleEvent<VehicleState>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await self.getVehicleState(vehicle)
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }
    
    public func getVehicleConfig(_ vehicle: Vehicle) -> Single<VehicleConfig> {
        let future = Single<VehicleConfig>.create { (single: @escaping (SingleEvent<VehicleConfig>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await self.getVehicleConfig(vehicle)
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }
    
    public func wakeUp(_ vehicle: Vehicle) -> Single<Vehicle> {
        let future = Single<Vehicle>.create { (single: @escaping (SingleEvent<Vehicle>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await self.wakeUp(vehicle)
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }
    
    public func sendCommandToVehicle(_ vehicle: Vehicle, command: VehicleCommand) -> Single<CommandResponse> {
        let future = Single<CommandResponse>.create { (single: @escaping (SingleEvent<CommandResponse>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await self.sendCommandToVehicle(vehicle, command: command)
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }
    
    public func getProducts() -> Single<[Product]> {
        let future = Single<[Product]>.create { (single: @escaping (SingleEvent<[Product]>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await self.getProducts()
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }
        
    public func getEnergySiteStatus(siteID: String) -> Single<EnergySiteStatus> {
        let future = Single<EnergySiteStatus>.create { (single: @escaping (SingleEvent<EnergySiteStatus>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await self.getEnergySiteStatus(siteID: siteID)
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }

    public func getEnergySiteLiveStatus(siteID: String) -> Single<EnergySiteLiveStatus> {
        let future = Single<EnergySiteLiveStatus>.create { (single: @escaping (SingleEvent<EnergySiteLiveStatus>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await self.getEnergySiteLiveStatus(siteID: siteID)
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }

    public func getEnergySiteInfo(siteID: String) -> Single<EnergySiteInfo> {
        let future = Single<EnergySiteInfo>.create { (single: @escaping (SingleEvent<EnergySiteInfo>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await self.getEnergySiteInfo(siteID: siteID)
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }

    public func getEnergySiteHistory(siteID: String, period: EnergySiteHistory.Period) -> Single<EnergySiteHistory> {
        let future = Single<EnergySiteHistory>.create { (single: @escaping (SingleEvent<EnergySiteHistory>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await self.getEnergySiteHistory(siteID: siteID, period: period)
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }

    public func getBatteryStatus(batteryID: String) -> Single<BatteryStatus> {
        let future = Single<BatteryStatus>.create { (single: @escaping (SingleEvent<BatteryStatus>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await   self.getBatteryStatus(batteryID: batteryID)
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }

    public func getBatteryData(batteryID: String) -> Single<BatteryData> {
        let future = Single<BatteryData>.create { (single: @escaping (SingleEvent<BatteryData>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await  self.getBatteryData(batteryID: batteryID)
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }

    public func getBatteryPowerHistory(batteryID: String) -> Single<BatteryPowerHistory> {
        let future = Single<BatteryPowerHistory>.create { (single: @escaping (SingleEvent<BatteryPowerHistory>) -> Void) -> Disposable in
            Task {
                do {
                    let result = try await self.getBatteryPowerHistory(batteryID: batteryID)
                    single(.success(result))
                } catch let error {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
        }
        return future
    }
}
