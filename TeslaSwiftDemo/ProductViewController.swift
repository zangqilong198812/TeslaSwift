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
        if let energySite = energySite {
            api.getEnergySiteStatus(siteID: "\(energySite.energySiteID)") { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self.textView.text = response.jsonString
                    case .failure(let error):
                        self.textView.text = error.localizedDescription
                    }
                }
            }
        }
    }
    
    @IBAction func getEnergySiteLiveStatus(_ sender: Any) {
        if let energySite = energySite {
            api.getEnergySiteLiveStatus(siteID: "\(energySite.energySiteID)") { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self.textView.text = response.jsonString
                    case .failure(let error):
                        self.textView.text = error.localizedDescription
                    }
                }
            }
        }
    }
    
    @IBAction func getEnergySiteInfo(_ sender: Any) {
        if let energySite = energySite {
            api.getEnergySiteInfo(siteID: "\(energySite.energySiteID)") { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self.textView.text = response.jsonString
                    case .failure(let error):
                        self.textView.text = error.localizedDescription
                    }
                }
            }
        }
    }
    
    @IBAction func getEnergySiteHistory(_ sender: Any) {
        if let energySite = energySite {
            api.getEnergySiteHistory(siteID: "\(energySite.energySiteID)", period: .day) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self.textView.text = response.jsonString
                    case .failure(let error):
                        self.textView.text = error.localizedDescription
                    }
                }
            }
        }
    }
    
    @IBAction func getBatteryStatus(_ sender: Any) {
        if let energySiteId = energySite?.id {
            api.getBatteryStatus(batteryID: "\(energySiteId)") { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self.textView.text = response.jsonString
                    case .failure(let error):
                        self.textView.text = error.localizedDescription
                    }
                }
            }
        }
    }
    
    @IBAction func getBatteryData(_ sender: Any) {
        if let energySiteId = energySite?.id {
            api.getBatteryData(batteryID: "\(energySiteId)") { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self.textView.text = response.jsonString
                    case .failure(let error):
                        self.textView.text = error.localizedDescription
                    }
                }
            }
        }
    }
    
    @IBAction func getBatteryPowerHistory(_ sender: Any) {
        if let energySiteId = energySite?.id {
            api.getBatteryPowerHistory(batteryID: "\(energySiteId)") { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self.textView.text = response.jsonString
                    case .failure(let error):
                        self.textView.text = error.localizedDescription
                    }
                }
            }
        }
    }

}
