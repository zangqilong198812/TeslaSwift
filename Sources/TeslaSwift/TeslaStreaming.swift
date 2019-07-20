//
//  TeslaStreaming.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 23/04/2017.
//  Copyright © 2017 Joao Nunes. All rights reserved.
//

import Foundation

/*
 * Streaming class takes care of the different types of data streaming from Tesla servers
 *
 */
public class TeslaStreaming {
	
	var debuggingEnabled = false
	var httpStreaming = HTTPEventStreaming()
	
    public init() { }
    
    public func openStream(endpoint: StreamEndpoint, dataReceived: @escaping (TeslaStreamingEvent) -> Void) {
		
		let authentication = endpoint.authentication
		let url = endpoint.baseURL() + endpoint.path
		
		logDebug("Opening Stream to: \(url)", debuggingEnabled: debuggingEnabled)
		
		httpStreaming.openCallback = {
			logDebug("Stream open", debuggingEnabled: self.debuggingEnabled)
            dataReceived(TeslaStreamingEvent.open)
		}
		
		httpStreaming.callback = {
			data in
			logDebug("Stream data: \(data)", debuggingEnabled: self.debuggingEnabled)
			
			let event = StreamEvent(values: data)
			
			DispatchQueue.main.async {
				dataReceived(TeslaStreamingEvent.event(event))
			}
		}
		
		httpStreaming.errorCallback = {
			(error: Error) in
			
			logDebug("Stream error: \(String(describing: error))", debuggingEnabled: self.debuggingEnabled)
			
			DispatchQueue.main.async {
				dataReceived(TeslaStreamingEvent.error(error))
			}
		}
        
        httpStreaming.closeCallback = {
            logDebug("Stream disconnected", debuggingEnabled: self.debuggingEnabled)
            dataReceived(TeslaStreamingEvent.disconnected)
        }
		
		httpStreaming.connect(url: URL(string: url)!, username: authentication.email, password: authentication.vehicleToken)
	}
	
	public func closeStream() {
		httpStreaming.disconnect()
		logDebug("Stream closed", debuggingEnabled: self.debuggingEnabled)
	}

}
