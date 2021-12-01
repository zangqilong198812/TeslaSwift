//
//  EnergySite.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

// MARK: - EnergySite
open class EnergySite: Codable {
    let energySiteID: Int
    let resourceType, siteName, id, gatewayID: String
    let assetSiteID: String
    let energyLeft, totalPackEnergy, percentageCharged: Int
    let batteryType: String
    let backupCapable: Bool
    let batteryPower: Int
    let syncGridAlertEnabled, breakerAlertEnabled: Bool
    let components: Components

    enum CodingKeys: String, CodingKey {
        case energySiteID = "energy_site_id"
        case resourceType = "resource_type"
        case siteName = "site_name"
        case id
        case gatewayID = "gateway_id"
        case assetSiteID = "asset_site_id"
        case energyLeft = "energy_left"
        case totalPackEnergy = "total_pack_energy"
        case percentageCharged = "percentage_charged"
        case batteryType = "battery_type"
        case backupCapable = "backup_capable"
        case batteryPower = "battery_power"
        case syncGridAlertEnabled = "sync_grid_alert_enabled"
        case breakerAlertEnabled = "breaker_alert_enabled"
        case components
    }
    
    
    // MARK: - Components
    struct Components: Codable {
        let battery: Bool
        let batteryType: String
        let solar: Bool
        let solarType: String
        let grid, loadMeter: Bool
        let marketType: String

        enum CodingKeys: String, CodingKey {
            case battery
            case batteryType = "battery_type"
            case solar
            case solarType = "solar_type"
            case grid
            case loadMeter = "load_meter"
            case marketType = "market_type"
        }
    }
}
