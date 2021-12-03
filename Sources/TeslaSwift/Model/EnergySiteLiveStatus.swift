//
//  EnergySiteLiveStatus.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

// MARK: - EnergySiteLiveStatus
open class EnergySiteLiveStatus: Codable {
    open var solarPower: Int
    open var energyLeft: Int
    open var totalPackEnergy: Int
    open var percentageCharged: Int
    open var backupCapable: Bool
    open var batteryPower: Int
    open var loadPower: Int
    open var gridStatus: String
    open var gridServicesActive: Bool
    open var gridPower: Int
    open var gridServicesPower: Int
    open var generatorPower: Int
    open var islandStatus: String
    open var stormModeActive: Bool
    open var timestamp: Date

    enum CodingKeys: String, CodingKey {
        case solarPower = "solar_power"
        case energyLeft = "energy_left"
        case totalPackEnergy = "total_pack_energy"
        case percentageCharged = "percentage_charged"
        case backupCapable = "backup_capable"
        case batteryPower = "battery_power"
        case loadPower = "load_power"
        case gridStatus = "grid_status"
        case gridServicesActive = "grid_services_active"
        case gridPower = "grid_power"
        case gridServicesPower = "grid_services_power"
        case generatorPower = "generator_power"
        case islandStatus = "island_status"
        case stormModeActive = "storm_mode_active"
        case timestamp
    }
}
