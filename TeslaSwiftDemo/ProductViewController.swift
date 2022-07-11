//
//  ProductViewController.swift
//  TeslaSwift
//
//  Created by Alec on 11/24/21.
//  Copyright © 2021 Joao Nunes. All rights reserved.
//

import UIKit
import CoreLocation

class ProductViewController: UIViewController {
    

    @IBOutlet private weak var textView: UITextView!
    
    var product: Product?
    
    var energySite: EnergySite? {
        return product?.energySite
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // This page is best suited for Energy Sites, but Vehicles are also returned in the Product API
        guard energySite != nil else {
            textView.text = "Select the Vehicle tab to interact with a vehicle"
            textView.isEditable = false
            return
        }
        
        textView.isEditable = true
    }
    
    

    @IBAction func getEnergySiteStatus(_ sender: Any) {
        guard let energySite = energySite else { return }
        Task { @MainActor in
            do {
            let response = try await api.getEnergySiteStatus(siteID: "\(energySite.energySiteID)")
            self.textView.text = response.jsonString
            } catch let error {
                self.textView.text = error.localizedDescription
            }
        }
    }
    
    @IBAction func getEnergySiteLiveStatus(_ sender: Any) {
        guard let energySite = energySite else { return }
        Task { @MainActor in
            do {
                let response = try await api.getEnergySiteLiveStatus(siteID: "\(energySite.energySiteID)")
                self.textView.text = response.jsonString
            } catch let error {
                self.textView.text = error.localizedDescription
            }
        }
    }
    
    @IBAction func getEnergySiteInfo(_ sender: Any) {
        guard let energySite = energySite else { return }
        Task { @MainActor in
            do {
                let response = try await api.getEnergySiteInfo(siteID: "\(energySite.energySiteID)")
                self.textView.text = response.jsonString
            } catch let error {
                self.textView.text = error.localizedDescription
            }
        }
    }
    
    @IBAction func getEnergySiteHistory(_ sender: Any) {
        guard let energySite = energySite else { return }
        Task { @MainActor in
            do {
                let response = try await api.getEnergySiteHistory(siteID: "\(energySite.energySiteID)", period: .day)
                self.textView.text = response.jsonString
            } catch let error {
                self.textView.text = error.localizedDescription
            }
        }
    }
    
    @IBAction func getBatteryStatus(_ sender: Any) {
        guard let energySiteId = energySite?.id else { return }
        Task { @MainActor in
            do {
                let response = try await api.getBatteryStatus(batteryID: "\(energySiteId)")
                self.textView.text = response.jsonString
            } catch let error {
                self.textView.text = error.localizedDescription
            }
        }
    }
    
    @IBAction func getBatteryData(_ sender: Any) {
        guard let energySiteId = energySite?.id else { return }
        Task { @MainActor in
            do {
                let response = try await api.getBatteryData(batteryID: "\(energySiteId)")
                self.textView.text = response.jsonString
            } catch let error {
                self.textView.text = error.localizedDescription
            }
        }
    }
    
    @IBAction func getBatteryPowerHistory(_ sender: Any) {
        guard let energySiteId = energySite?.id else { return }
        Task { @MainActor in
            do {
                let response = try await api.getBatteryPowerHistory(batteryID: "\(energySiteId)")
                self.textView.text = response.jsonString
            } catch let error {
                self.textView.text = error.localizedDescription
            }
        }
    }
}
