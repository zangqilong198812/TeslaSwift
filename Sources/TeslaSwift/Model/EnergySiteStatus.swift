//
//  EnergySiteStatus.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

// MARK: - EnergySiteStatus
open class EnergySiteStatus: Codable {
    let resourceType, siteName, gatewayID: String
    let energyLeft, totalPackEnergy, percentageCharged: Int
    let batteryType: String
    let backupCapable: Bool
    let batteryPower: Int
    let syncGridAlertEnabled, breakerAlertEnabled: Bool

    enum CodingKeys: String, CodingKey {
        case resourceType = "resource_type"
        case siteName = "site_name"
        case gatewayID = "gateway_id"
        case energyLeft = "energy_left"
        case totalPackEnergy = "total_pack_energy"
        case percentageCharged = "percentage_charged"
        case batteryType = "battery_type"
        case backupCapable = "backup_capable"
        case batteryPower = "battery_power"
        case syncGridAlertEnabled = "sync_grid_alert_enabled"
        case breakerAlertEnabled = "breaker_alert_enabled"
    }
}
