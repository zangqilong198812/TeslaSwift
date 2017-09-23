//
//  OpenTrunkOptions.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 16/04/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation

public enum OpenTrunkOptions: String, Codable {
	
	case Rear = "rear"
	
	enum CodingKeys: String, CodingKey {
		typealias RawValue = String
		
		case Rear	= "which_trunk"
	}
}
