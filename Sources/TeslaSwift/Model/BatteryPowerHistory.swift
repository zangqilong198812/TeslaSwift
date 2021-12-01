//
//  BatteryPowerHistory.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

// MARK: - BatteryPowerHistory
open class BatteryPowerHistory: Codable {
    let serialNumber: String
    let timeSeries: [TimeSeries]
    let selfConsumptionData: [SelfConsumptionDatum]

    enum CodingKeys: String, CodingKey {
        case serialNumber = "serial_number"
        case timeSeries = "time_series"
        case selfConsumptionData = "self_consumption_data"
    }
    
    
    // MARK: - SelfConsumptionDatum
    struct SelfConsumptionDatum: Codable {
        let timestamp: Date
        let solar, battery: Double
    }

    // MARK: - TimeSeries
    struct TimeSeries: Codable {
        let timestamp: Date
        let solarPower, batteryPower, gridPower: Double
        let gridServicesPower, generatorPower: Int

        enum CodingKeys: String, CodingKey {
            case timestamp
            case solarPower = "solar_power"
            case batteryPower = "battery_power"
            case gridPower = "grid_power"
            case gridServicesPower = "grid_services_power"
            case generatorPower = "generator_power"
        }
    }
}
