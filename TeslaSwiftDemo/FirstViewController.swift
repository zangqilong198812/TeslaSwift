//
//  FirstViewController.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 04/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	
	var data:[Vehicle]?
	

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		tableView.estimatedRowHeight = 50.0
		
		api.getVehicles()
			.then {
			(response) -> Void in
			
			self.data = response
			self.tableView.reloadData()
			
			}.catch { (error) in
				//Process error
		}
		
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		
		let vehicle = data![(indexPath as NSIndexPath).row]
		
		cell.textLabel?.text = vehicle.vin
		cell.detailTextLabel?.text = vehicle.state
		
		
		return cell
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		
		if segue.identifier == "toDetail" {
			
			if let indexPath = tableView.indexPathForSelectedRow {
				let vc = segue.destination as! VehicleViewController
				vc.vehicle = data![indexPath.row]
			}
			
		}
	}

}

