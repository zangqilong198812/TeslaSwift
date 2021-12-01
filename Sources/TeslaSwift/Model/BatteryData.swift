//
//  BatteryData.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

// MARK: - Welcome
open class BatteryData: Codable {
    let siteName: String
    let energyLeft, totalPackEnergy: Int
    let gridStatus: String
    let backup: Backup
    let userSettings: UserSettings
    let components: Components
    let defaultRealMode, operation: String
    let installationDate: Date
    let powerReading: [PowerReading]
    let batteryCount: Int

    enum CodingKeys: String, CodingKey {
        case siteName = "site_name"
        case energyLeft = "energy_left"
        case totalPackEnergy = "total_pack_energy"
        case gridStatus = "grid_status"
        case backup
        case userSettings = "user_settings"
        case components
        case defaultRealMode = "default_real_mode"
        case operation
        case installationDate = "installation_date"
        case powerReading = "power_reading"
        case batteryCount = "battery_count"
    }
    
    
    // MARK: - Backup
    struct Backup: Codable {
        let backupReservePercent: Int
        let events: [Event]

        enum CodingKeys: String, CodingKey {
            case backupReservePercent = "backup_reserve_percent"
            case events
        }
    }

    // MARK: - Event
    struct Event: Codable {
        let timestamp: Date
        let duration: Int
    }

    // MARK: - Components
    struct Components: Codable {
        let solar: Bool
        let solarType: String
        let battery, grid, backup: Bool
        let gateway: String
        let loadMeter, touCapable, stormModeCapable, flexEnergyRequestCapable: Bool
        let carChargingDataSupported, offGridVehicleChargingReserveSupported, vehicleChargingPerformanceViewEnabled, vehicleChargingSolarOffsetViewEnabled: Bool
        let batterySolarOffsetViewEnabled, setIslandingModeEnabled, backupTimeRemainingEnabled: Bool
        let batteryType: String
        let configurable, gridServicesEnabled: Bool

        enum CodingKeys: String, CodingKey {
            case solar
            case solarType = "solar_type"
            case battery, grid, backup, gateway
            case loadMeter = "load_meter"
            case touCapable = "tou_capable"
            case stormModeCapable = "storm_mode_capable"
            case flexEnergyRequestCapable = "flex_energy_request_capable"
            case carChargingDataSupported = "car_charging_data_supported"
            case offGridVehicleChargingReserveSupported = "off_grid_vehicle_charging_reserve_supported"
            case vehicleChargingPerformanceViewEnabled = "vehicle_charging_performance_view_enabled"
            case vehicleChargingSolarOffsetViewEnabled = "vehicle_charging_solar_offset_view_enabled"
            case batterySolarOffsetViewEnabled = "battery_solar_offset_view_enabled"
            case setIslandingModeEnabled = "set_islanding_mode_enabled"
            case backupTimeRemainingEnabled = "backup_time_remaining_enabled"
            case batteryType = "battery_type"
            case configurable
            case gridServicesEnabled = "grid_services_enabled"
        }
    }

    // MARK: - PowerReading
    struct PowerReading: Codable {
        let timestamp: Date
        let loadPower, solarPower, gridPower, batteryPower: Int
        let generatorPower: Int

        enum CodingKeys: String, CodingKey {
            case timestamp
            case loadPower = "load_power"
            case solarPower = "solar_power"
            case gridPower = "grid_power"
            case batteryPower = "battery_power"
            case generatorPower = "generator_power"
        }
    }

    // MARK: - UserSettings
    struct UserSettings: Codable {
        let stormModeEnabled, syncGridAlertEnabled, breakerAlertEnabled: Bool

        enum CodingKeys: String, CodingKey {
            case stormModeEnabled = "storm_mode_enabled"
            case syncGridAlertEnabled = "sync_grid_alert_enabled"
            case breakerAlertEnabled = "breaker_alert_enabled"
        }
    }
}
