//
//  Codable+JSONString.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 23/09/2017.
//  Copyright © 2017 Joao Nunes. All rights reserved.
//

import Foundation

public extension Encodable {
	
	var jsonString: String? {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		guard let data = try? encoder.encode(self) else { return nil }
		return String(data: data, encoding: String.Encoding.utf8)
	}
	
	var jsonObject: Any? {
		guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else { return nil }
		return try? JSONSerialization.data(withJSONObject: data, options: [])
	}
}

public extension String {
	public func decodeJSON<T: Decodable>() -> T? {
		guard let data = self.data(using: String.Encoding.utf8) else { return nil }
		return try? teslaJSONDecoder.decode(T.self, from: data)
	}
}
