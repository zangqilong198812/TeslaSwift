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
	
	func responseObjectFuture<T: Mappable>(keyPath: String?) -> Future<T,TeslaError> {
		
		let promise = Promise<T, TeslaError>()
		
		responseObject(keyPath) { (response:Response<T, NSError>) -> Void in
		
			switch(response.result){
			case .Success(let value):
				print("Result: \(response.result.value!)")
				promise.success(value)
			case .Failure(let error):
				print("Result: \(response.result.error!)")
				promise.failure(TeslaError.NetworkError(error: error))
			}
		
		}
		
		return promise.future
	}
	
	func responseObjectFuture<T: Mappable>(keyPath: String?) -> Future<[T],TeslaError> {
		
		let promise = Promise<[T], TeslaError>()
		
		responseArray(keyPath) { (response:Response<[T], NSError>) -> Void in
			
			switch(response.result){
			case .Success(let value):
				print("Result: \(response.result.value!)")
				promise.success(value)
			case .Failure(let error):
				print("Result: \(response.result.error!)")
				promise.failure(TeslaError.NetworkError(error: error))
			}
			
		}
		
		return promise.future
	}

}
