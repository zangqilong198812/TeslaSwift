//
//  EnergySiteHistory.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import Foundation

// MARK: - EnergySiteHistory
open class EnergySiteHistory: Codable {
    let serialNumber, period: String
    let timeSeries: [TimeSeries]

    enum CodingKeys: String, CodingKey {
        case serialNumber = "serial_number"
        case period
        case timeSeries = "time_series"
    }
    
    public enum Period: String {
        case day, week, month, year
    }
    
    // MARK: - TimeSeries
    struct TimeSeries: Codable {
        let timestamp: Date
        let solarEnergyExported, generatorEnergyExported, gridEnergyImported, gridServicesEnergyImported, gridServicesEnergyExported, gridEnergyExportedFromSolar, gridEnergyExportedFromGenerator, gridEnergyExportedFromBattery, batteryEnergyExported, batteryEnergyImportedFromGrid, batteryEnergyImportedFromSolar, batteryEnergyImportedFromGenerator, consumerEnergyImportedFromGrid, consumerEnergyImportedFromSolar, consumerEnergyImportedFromBattery, consumerEnergyImportedFromGenerator: Double

        enum CodingKeys: String, CodingKey {
            case timestamp
            case solarEnergyExported = "solar_energy_exported"
            case generatorEnergyExported = "generator_energy_exported"
            case gridEnergyImported = "grid_energy_imported"
            case gridServicesEnergyImported = "grid_services_energy_imported"
            case gridServicesEnergyExported = "grid_services_energy_exported"
            case gridEnergyExportedFromSolar = "grid_energy_exported_from_solar"
            case gridEnergyExportedFromGenerator = "grid_energy_exported_from_generator"
            case gridEnergyExportedFromBattery = "grid_energy_exported_from_battery"
            case batteryEnergyExported = "battery_energy_exported"
            case batteryEnergyImportedFromGrid = "battery_energy_imported_from_grid"
            case batteryEnergyImportedFromSolar = "battery_energy_imported_from_solar"
            case batteryEnergyImportedFromGenerator = "battery_energy_imported_from_generator"
            case consumerEnergyImportedFromGrid = "consumer_energy_imported_from_grid"
            case consumerEnergyImportedFromSolar = "consumer_energy_imported_from_solar"
            case consumerEnergyImportedFromBattery = "consumer_energy_imported_from_battery"
            case consumerEnergyImportedFromGenerator = "consumer_energy_imported_from_generator"
        }
    }
}
