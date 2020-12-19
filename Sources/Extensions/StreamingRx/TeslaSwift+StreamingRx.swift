//
//  TeslaSwift+StreamingRx.swift
//  TeslaSwift
//
//  Created by João Nunes on 19/12/2020.
//  Copyright © 2020 Joao Nunes. All rights reserved.
//

import Foundation
import RxSwift
#if COCOAPODS
#else // SPM
import TeslaSwift
#endif

extension TeslaSwift  {

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
                        observer.onNext(TeslaStreamingEvent.open)
                    case .event(let event):
                        observer.onNext(TeslaStreamingEvent.event(event))
                    case .error(let error):
                        observer.onError(error)
                    case .disconnected:
                        observer.onNext(TeslaStreamingEvent.disconnected)
                        observer.onCompleted()
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
