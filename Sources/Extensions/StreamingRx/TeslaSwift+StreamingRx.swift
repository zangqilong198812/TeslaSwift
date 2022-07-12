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
import TeslaSwiftStreaming
#endif

extension TeslaStreaming {
    public func streamPublisher(vehicle: Vehicle) -> TeslaStreamingRxPublisher {
        return TeslaStreamingRxPublisher(vehicle: vehicle, stream: self)
    }

    public class TeslaStreamingRxPublisher: ObservableType, Disposable {
        public typealias Element = TeslaStreamingEvent

        let vehicle: Vehicle
        let stream: TeslaStreaming

        init(vehicle: Vehicle, stream: TeslaStreaming) {
            self.vehicle = vehicle
            self.stream = stream
        }

        public func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer : ObserverType, TeslaStreamingRxPublisher.Element == Observer.Element {
            Task {
                do {
                    for try await streamEvent in try await stream.openStream(vehicle: vehicle) {
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
                } catch let error {
                    observer.onError(error)
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
}
