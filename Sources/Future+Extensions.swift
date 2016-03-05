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
	
	/*
	func responseJSONFuture() -> Future<AnyObject,TeslaError> {
		
		let promise = Promise<AnyObject, TeslaError>()
		responseJSON { response in
			
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
	}*/
}
/*
extension Mapper {
	
	func mapFuture(JSON: AnyObject?) -> Future<N,TeslaError> {
		
		let value = self.map(JSON)
		if let value = value {
			return Future<N,TeslaError>(value: value)
		} else {
			return Future<N,TeslaError>(error: .JSONParsingError(error: NSError(domain: "TeslaSwift", code: 0, userInfo: nil)))
		}
		
	}
	func mapArrayFuture(JSON: AnyObject?) -> Future<[N],TeslaError> {
		
		let value = self.mapArray(JSON)
		if let value = value {
			return Future<[N],TeslaError>(value: value)
		} else {
			return Future<[N],TeslaError>(error: .JSONParsingError(error: NSError(domain: "TeslaSwift", code: 0, userInfo: nil)))
		}
		
	}
	
}*/