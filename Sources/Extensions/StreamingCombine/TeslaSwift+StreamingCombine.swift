//
//  TeslaSwift+StreamingCombine.swift
//  TeslaSwift
//
//  Created by João Nunes on 19/12/2020.
//  Copyright © 2020 Joao Nunes. All rights reserved.
//

#if swift(>=5.1)
import Combine
#if COCOAPODS
#else // SPM
import TeslaSwift
#endif

@available(iOS 13.0, macOS 10.15, watchOS 6, tvOS 13, *)
extension TeslaSwift  {

    public func streamPublisher(vehicle: Vehicle) -> TeslaStreamingPublisher {

        guard let email = email,
              let vehicleToken = vehicle.tokens?.first else {
            //dataReceived((nil, TeslaError.streamingMissingEmailOrVehicleToken))
            let authentication = TeslaStreamAuthentication(email: "", vehicleToken: "", vehicleId: "\(vehicle.vehicleID!)")
            return streamPublisher(authentication: authentication)
        }

        let authentication = TeslaStreamAuthentication(email: email, vehicleToken: vehicleToken, vehicleId: "\(vehicle.vehicleID!)")


        return streamPublisher(authentication: authentication)
    }

    public struct TeslaStreamingPublisher: Publisher, Cancellable {

        public typealias Output = TeslaStreamingEvent
        public typealias Failure = Error

        let authentication: TeslaStreamAuthentication
        let stream: TeslaStreaming

        init(authentication: TeslaStreamAuthentication, stream: TeslaStreaming) {
            self.authentication = authentication
            self.stream = stream
        }

        public func receive<S>(subscriber: S) where S : Subscriber, TeslaStreamingPublisher.Failure == S.Failure, TeslaStreamingPublisher.Output == S.Input {

            stream.openStream(authentication: authentication) {
                (streamEvent: TeslaStreamingEvent) in

                switch streamEvent {
                    case .open:
                        _ = subscriber.receive(TeslaStreamingEvent.open)
                    case .event(let event):
                        _ = subscriber.receive(TeslaStreamingEvent.event(event))
                    case .error(let error):
                        _ = subscriber.receive(TeslaStreamingEvent.error(error))
                    case .disconnected:
                        _ = subscriber.receive(TeslaStreamingEvent.disconnected)
                        subscriber.receive(completion: Subscribers.Completion.finished)
                }

            }

        }

        public func cancel() {
            stream.closeStream()
        }

    }

    func streamPublisher(authentication: TeslaStreamAuthentication) -> TeslaStreamingPublisher {

        return TeslaStreamingPublisher(authentication: authentication, stream: TeslaStreaming())
    }

}

#endif
