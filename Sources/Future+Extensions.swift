//
//  Future+Extensions.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 05/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import BrightFutures
import AlamofireObjectMapper

extension Alamofire.Request {
	
	func responseObjectFuture<T: Mappable>(keyPath: String?, logging:Bool = false) -> Future<T,TeslaError> {
		
		let promise = Promise<T, TeslaError>()
		
		responseObject(keyPath) { (response:Response<T, NSError>) -> Void in
			
			switch(response.result) {
			case .Success(let value):
				promise.success(value)
			case .Failure(let error):
				promise.failure(TeslaError.NetworkError(error: error))
			}
			}.responseString { (response) -> Void in
				switch(response.result) {
				case .Success(let value):
					logDebug("Result: \(value)", debuggingEnabled: logging)
				case .Failure(let error):
					logDebug("Result error: \(error as NSError)", debuggingEnabled: logging)
				}
				
		}
		
		return promise.future
	}
	
	func responseObjectFuture<T: Mappable>(keyPath: String?, logging:Bool = false) -> Future<[T],TeslaError> {
		
		let promise = Promise<[T], TeslaError>()
		
		responseArray(keyPath) { (response:Response<[T], NSError>) -> Void in
			
			switch(response.result) {
			case .Success(let value):
				promise.success(value)
			case .Failure(let error):
				promise.failure(TeslaError.NetworkError(error: error))
			}
			
		}.responseString { (response) -> Void in
			switch(response.result) {
			case .Success(let value):
				logDebug("Result: \(value)", debuggingEnabled: logging)
			case .Failure(let error):
				logDebug("Result: \(error as NSError)", debuggingEnabled: logging)
			}
		}
		
		return promise.future
	}
	
	func responseObjectFuture(logging:Bool = false) -> Future<AnyObject,TeslaError> {
		
		let promise = Promise<AnyObject, TeslaError>()
		
		responseJSON { (response:Response<AnyObject, NSError>) -> Void in
			
			switch(response.result) {
			case .Success(let value):
				promise.success(value)
			case .Failure(let error):
				promise.failure(TeslaError.NetworkError(error: error))
			}
			
			}.responseString { (response) -> Void in
				switch(response.result) {
				case .Success(let value):
					logDebug("Result: \(value)", debuggingEnabled: logging)
				case .Failure(let error):
					logDebug("Result: \(error as NSError)", debuggingEnabled: logging)
				}
		}
		
		return promise.future
	}

}
