//
//  CommandResponse.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 05/04/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation

open class CommandResponse: Codable {
	
	private struct Response: Codable {
		var result: Int?
		var reason: String?
	}
	private var response: Response
	
	open var result: Bool? { return response.result == 1 }
	open var reason: String? { return response.reason }
	
	enum CodingKeys: String, CodingKey {
		case response
	}
}
