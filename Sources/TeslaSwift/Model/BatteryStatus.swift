//
//  BatteryStatus.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

// MARK: - BatteryStatus
open class BatteryStatus: Codable {
    let siteName, id: String
    let energyLeft, totalPackEnergy, percentageCharged, batteryPower: Int

    enum CodingKeys: String, CodingKey {
        case siteName = "site_name"
        case id
        case energyLeft = "energy_left"
        case totalPackEnergy = "total_pack_energy"
        case percentageCharged = "percentage_charged"
        case batteryPower = "battery_power"
    }
}
