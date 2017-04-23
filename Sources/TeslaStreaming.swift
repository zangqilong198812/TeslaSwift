//
//  TeslaStreaming.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 23/04/2017.
//  Copyright © 2017 Joao Nunes. All rights reserved.
//

import Foundation
import IKEventSource

/*
 * Streaming class takes care of the different types of data streaming from Tesla servers
 *
 */
class TeslaStreaming {
	
	var debuggingEnabled = false
	var eventSource: EventSource!
	
	func openStream(endpoint: StreamEndpoint, dataReceived: @escaping (StreamEvent) -> Void) {
		
		let authentication = endpoint.authentication
		let basicAuth = EventSource.basicAuth(authentication.email, password: authentication.vehicleToken)
		let url = endpoint.baseURL(false) + endpoint.path
		
		logDebug("Opening Stream to: \(url)", debuggingEnabled: debuggingEnabled)
		
		eventSource = EventSource(url: url, headers: ["Authorization": basicAuth])
		
		eventSource.onOpen {
			// When opened
			print("eventSource is open")
		}
		
		eventSource.onError { (error) in
			// When errors
			print("eventSource error: \(String(describing: error?.localizedDescription))")
		}
		
		eventSource.onMessage { (id, event, data) in
			// Here you get an event without event name!
			print("data: \(data)")
			print("data: \(id)")
			print("data: \(event)")
		}
		
		eventSource.addEventListener("event-name") { (id, event, data) in
			// Here you get an event 'event-name'
			print("data: \(data)")
			print("data: \(id)")
			print("data: \(event)")
		}
		
	}
	
	public func closeStream() {
		eventSource?.close()
	}

}
