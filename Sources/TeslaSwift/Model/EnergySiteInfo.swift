//
//  EnergySiteInfo.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

// MARK: - EnergySiteInfo
open class EnergySiteInfo: Codable {
    let id, siteName: String
    let backupReservePercent: Int
    let defaultRealMode: String
    let installationDate: Date
    let userSettings: UserSettings
    let components: Components
    let version: String
    let batteryCount: Int
    let touSettings: TOUSettings
    let nameplatePower, nameplateEnergy: Int
    let installationTimeZone: String
    let offGridVehicleChargingReservePercent: Int

    enum CodingKeys: String, CodingKey {
        case id
        case siteName = "site_name"
        case backupReservePercent = "backup_reserve_percent"
        case defaultRealMode = "default_real_mode"
        case installationDate = "installation_date"
        case userSettings = "user_settings"
        case components, version
        case batteryCount = "battery_count"
        case touSettings = "tou_settings"
        case nameplatePower = "nameplate_power"
        case nameplateEnergy = "nameplate_energy"
        case installationTimeZone = "installation_time_zone"
        case offGridVehicleChargingReservePercent = "off_grid_vehicle_charging_reserve_percent"
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

    // MARK: - TouSettings
    struct TOUSettings: Codable {
        let optimizationStrategy: String
        let schedule: [Schedule]

        enum CodingKeys: String, CodingKey {
            case optimizationStrategy = "optimization_strategy"
            case schedule
        }
    }

    // MARK: - Schedule
    struct Schedule: Codable {
        let target: String
        let weekDays: [Int]
        let startSeconds, endSeconds: Int

        enum CodingKeys: String, CodingKey {
            case target
            case weekDays = "week_days"
            case startSeconds = "start_seconds"
            case endSeconds = "end_seconds"
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
