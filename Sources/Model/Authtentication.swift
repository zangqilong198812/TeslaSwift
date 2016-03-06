//
//  AuthToken.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 04/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

public class AuthToken:Mappable {
	
	var accessToken:String?
	var tokenType:String?
	var createdAt:NSDate? = NSDate()
	var expiresIn:NSTimeInterval?
	
	var isValid:Bool {
		if let createdAt = createdAt, expiresIn = expiresIn {
			return -NSDate().timeIntervalSinceDate(createdAt) < expiresIn
		} else {
			return false
		}
	}
	
	
	//MARK: Mappable protocol
	required public init?(_ map: Map){
		
	}
	
	public func mapping(map: Map) {
		accessToken	<- map["access_token"]
		tokenType	<- map["token_type"]
		createdAt	<- (map["created_at"], DateTransform())
		expiresIn	<- (map["expires_in"], TransformOf<NSTimeInterval, Int>(fromJSON: { NSTimeInterval($0! / 1000) }, toJSON: { Int($0!) * 1000 }))
	}
}

class AuthTokenRequest: Mappable {
	
	var grantType:String?
	var clientID:String?
	var clientSecret:String?
	var email:String?
	var password:String?
	
	init() { }
	
	//MARK: Mappable protocol
	required init?(_ map: Map){
		
	}
	
	func mapping(map: Map) {
		grantType		<- map["grant_type"]
		clientID		<- map["client_id"]
		clientSecret	<- map["client_secret"]
		email			<- map["email"]
		password		<- map["password"]
	}
}