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
    
    func singlefy<Value: Decodable>(subscriber: @escaping (SingleEvent<Value>) -> Void) -> ((Result<Value, Error>) -> ()) {
        
        return { (result: Result<Value, Error>) in
            
            switch result {
            case .success(let value):
                subscriber(.success(value))
            case .failure(let error):
                subscriber(.error(error))
            }
        }
        
    }
    
    public func authenticate(email: String, password: String) -> Single<AuthToken> {
       
        let future = Single<AuthToken>.create { (single: @escaping (SingleEvent<AuthToken>) -> Void) -> Disposable in
            
            self.authenticate(email: email, password: password, completion: self.singlefy(subscriber: single))
            
            return Disposables.create { }
        }
    
        return future
    }
    
    public func revoke() -> Single<Bool> {
        
        let future = Single<Bool>.create { (single: @escaping (SingleEvent<Bool>) -> Void) -> Disposable in
            
            self.revoke(completion: self.singlefy(subscriber: single))
            
            return Disposables.create { }
        }
        
        return future
    }
    
    public func getVehicles() -> Single<[Vehicle]> {
        
        let future = Single<[Vehicle]>.create { (single: @escaping (SingleEvent<[Vehicle]>) -> Void) -> Disposable in
            
            self.getVehicles(completion: self.singlefy(subscriber: single))
            
            return Disposables.create { }
        }
        
        return future
    }
    
    public func getVehicle(_ vehicleID: String) -> Single<Vehicle> {
        
        let future = Single<Vehicle>.create { (single: @escaping (SingleEvent<Vehicle>) -> Void) -> Disposable in
            
            self.getVehicle(vehicleID, completion: self.singlefy(subscriber: single))
            
            return Disposables.create { }
        }
        
        return future
    }
    
    public func getVehicle(_ vehicle: Vehicle) -> Single<Vehicle> {
        
        let future = Single<Vehicle>.create { (single: @escaping (SingleEvent<Vehicle>) -> Void) -> Disposable in
            
            self.getVehicle(vehicle, completion: self.singlefy(subscriber: single))
            
            return Disposables.create { }
        }
        
        return future
    }
    
    public func getAllData(_ vehicle: Vehicle) -> Single<VehicleExtended> {
        
        let future = Single<VehicleExtended>.create { (single: @escaping (SingleEvent<VehicleExtended>) -> Void) -> Disposable in
            
            self.getAllData(vehicle, completion: self.singlefy(subscriber: single))
            
            return Disposables.create { }
        }
        
        return future
    }
    
    public func getVehicleMobileAccessState(_ vehicle: Vehicle) -> Single<Bool> {
        
        let future = Single<Bool>.create { (single: @escaping (SingleEvent<Bool>) -> Void) -> Disposable in
            
            self.getVehicleMobileAccessState(vehicle, completion: self.singlefy(subscriber: single))
            
            return Disposables.create { }
        }
        
        return future
    }
    
    public func getVehicleChargeState(_ vehicle: Vehicle) -> Single<ChargeState> {
        
        let future = Single<ChargeState>.create { (single: @escaping (SingleEvent<ChargeState>) -> Void) -> Disposable in
            
            self.getVehicleChargeState(vehicle, completion: self.singlefy(subscriber: single))
         
            return Disposables.create { }
        }
        
        return future
    }
    
    public func getVehicleChargeState(_ vehicle: Vehicle) -> Single<ClimateState> {
        
        let future = Single<ClimateState>.create { (single: @escaping (SingleEvent<ClimateState>) -> Void) -> Disposable in
            
            self.getVehicleClimateState(vehicle, completion: self.singlefy(subscriber: single))
            
            return Disposables.create { }
        }
        
        return future
    }
    
    public func getVehicleDriveState(_ vehicle: Vehicle) -> Single<DriveState> {
        
        let future = Single<DriveState>.create { (single: @escaping (SingleEvent<DriveState>) -> Void) -> Disposable in
            
            self.getVehicleDriveState(vehicle, completion: self.singlefy(subscriber: single))
            
            return Disposables.create { }
        }
        
        return future
    }
    
    public func getVehicleGuiSettings(_ vehicle: Vehicle) -> Single<GuiSettings> {
        
        let future = Single<GuiSettings>.create { (single: @escaping (SingleEvent<GuiSettings>) -> Void) -> Disposable in
            
            self.getVehicleGuiSettings(vehicle, completion: self.singlefy(subscriber: single))
            
            return Disposables.create { }
        }
        
        return future
    }
    
    public func getVehicleState(_ vehicle: Vehicle) -> Single<VehicleState> {
        
        let future = Single<VehicleState>.create { (single: @escaping (SingleEvent<VehicleState>) -> Void) -> Disposable in
            
            self.getVehicleState(vehicle, completion: self.singlefy(subscriber: single))
            
            return Disposables.create { }
        }
        
        return future
    }
    
    public func getVehicleConfig(_ vehicle: Vehicle) -> Single<VehicleConfig> {
        
        let future = Single<VehicleConfig>.create { (single: @escaping (SingleEvent<VehicleConfig>) -> Void) -> Disposable in
            
            self.getVehicleConfig(vehicle, completion: self.singlefy(subscriber: single))
         
            return Disposables.create { }
        }
        
        return future
    }
    
    public func wakeUp(_ vehicle: Vehicle) -> Single<Vehicle> {
        
        let future = Single<Vehicle>.create { (single: @escaping (SingleEvent<Vehicle>) -> Void) -> Disposable in
            
            self.wakeUp(vehicle, completion: self.singlefy(subscriber: single))
            
            return Disposables.create { }
        }
        
        return future
    }
    
    public func sendCommandToVehicle(_ vehicle: Vehicle, command: VehicleCommand) -> Single<CommandResponse> {
        
        let future = Single<CommandResponse>.create { (single: @escaping (SingleEvent<CommandResponse>) -> Void) -> Disposable in
            
            self.sendCommandToVehicle(vehicle, command: command, completion: self.singlefy(subscriber: single))
            
            return Disposables.create { }
        }
        
        return future
    }
    
    public func streamPublisher(vehicle: Vehicle) -> TeslaStreamingRxPublisher {
        
        guard let email = email,
            let vehicleToken = vehicle.tokens?.first else {
                //dataReceived((nil, TeslaError.streamingMissingEmailOrVehicleToken))
                let authentication = TeslaStreamAuthentication(email: "", vehicleToken: "", vehicleId: "\(vehicle.vehicleID!)")
                return streamPublisher(authentication: authentication)
        }
        
        let authentication = TeslaStreamAuthentication(email: email, vehicleToken: vehicleToken, vehicleId: "\(vehicle.vehicleID!)")
        
        
        return streamPublisher(authentication: authentication)
    }
}

extension TeslaSwift  {
    
    public class TeslaStreamingRxPublisher: ObservableType, Disposable {
        
        public typealias Element = TeslaStreamingEvent
        
        let authentication: TeslaStreamAuthentication
        let stream: TeslaStreaming
        
        init(authentication: TeslaStreamAuthentication, stream: TeslaStreaming) {
            self.authentication = authentication
            self.stream = stream
        }
        
        public func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer : ObserverType, TeslaStreamingRxPublisher.Element == Observer.Element {
            
            stream.openStream(authentication: authentication) {
            (streamEvent: TeslaStreamingEvent) in
                
                switch streamEvent {
                case .open:
                    _ = observer.onNext(TeslaStreamingEvent.open)
                case .event(let event):
                    _ = observer.onNext(TeslaStreamingEvent.event(event))
                case .error(let error):
                    _ = observer.onError(error)
                case .disconnected:
                    _ = observer.onNext(TeslaStreamingEvent.disconnected)
                    _ = observer.onCompleted()
                }
                
            }
            
            return Disposables.create {
                self.stream.closeStream()
            }
            
        }
        
        public func dispose() {
            stream.closeStream()
        }
        
    }
    
    func streamPublisher(authentication: TeslaStreamAuthentication) -> TeslaStreamingRxPublisher {
        
        return TeslaStreamingRxPublisher(authentication: authentication, stream: TeslaStreaming())
    }
    
}
