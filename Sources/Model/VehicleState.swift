//
//  VehicleState.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 06/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import Foundation
import ObjectMapper

public class VehicleState {

	internal(set) var mobileAccess:Bool?
	internal(set) var chargeState:ChargeState?
}
